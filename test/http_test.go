package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

const ROOT_DOMAIN_NAME_FOR_TEST = "gcloud-test.com"
const MANAGED_ZONE_NAME_FOR_TEST = "gcloudtest"

//const ROOT_DOMAIN_NAME_FOR_TEST = "gcloud-dev.com"
//const MANAGED_ZONE_NAME_FOR_TEST = "gclouddev"

const KEY_PROJECT = "project"
const KEY_DOMAIN_NAME = "domain-name"
const KEY_NAME = "name"
const KEY_REGION = "region"
const KEY_AZ = "az"

const OUTPUT_LB_IP = "load_balancer_ip_address"

func TestHttpLoadBalancerMultiBackend(t *testing.T) {
	t.Parallel()

	var testcases = []struct {
		testName     string
		createDomain bool
		enableSsl    bool
		enableHttp   bool
	}{
		{
			"TestHttpAndIpOnly",
			false,
			false,
			true,
		},
		{
			"TestBothProtocolsWithDomain",
			true,
			true,
			true,
		},
	}

	for _, testCase := range testcases {
		// The following is necessary to make sure testCase's values don't
		// get updated due to concurrency within the scope of t.Run(..) below
		testCase := testCase

		t.Run(testCase.testName, func(t *testing.T) {
			t.Parallel()

			//os.Setenv("SKIP_bootstrap", "true")
			//os.Setenv("SKIP_deploy", "true")
			//os.Setenv("SKIP_http_tests", "true")
			//os.Setenv("SKIP_teardown", "true")

			// The example is the root example
			exampleDir := test_structure.CopyTerraformFolderToTemp(t, "../", ".")

			test_structure.RunTestStage(t, "bootstrap", func() {
				logger.Logf(t, "Bootstrapping variables")

				projectId := gcp.GetGoogleProjectIDFromEnvVar(t)
				region := getRandomRegion(t, projectId)
				az := gcp.GetRandomZoneForRegion(t, projectId, region)

				randomId := strings.ToLower(random.UniqueId())
				// Since some of the resources require the resource name to begin with a lower-case letter, we're prepending an 'a'
				randomId = fmt.Sprintf("a%s", randomId)

				domainName := fmt.Sprintf("%s.%s", randomId, ROOT_DOMAIN_NAME_FOR_TEST)

				test_structure.SaveString(t, exampleDir, KEY_DOMAIN_NAME, domainName)
				test_structure.SaveString(t, exampleDir, KEY_PROJECT, projectId)
				test_structure.SaveString(t, exampleDir, KEY_REGION, region)
				test_structure.SaveString(t, exampleDir, KEY_AZ, az)
				test_structure.SaveString(t, exampleDir, KEY_NAME, randomId)
			})

			// At the end of the test, run `terraform destroy` to clean up any resources that were created
			defer test_structure.RunTestStage(t, "teardown", func() {
				logger.Logf(t, "Tear down infrastructure")

				terraformOptions := test_structure.LoadTerraformOptions(t, exampleDir)
				terraform.Destroy(t, terraformOptions)
			})

			test_structure.RunTestStage(t, "deploy", func() {
				logger.Logf(t, "Deploying the solution")

				projectId := test_structure.LoadString(t, exampleDir, KEY_PROJECT)
				domainName := test_structure.LoadString(t, exampleDir, KEY_DOMAIN_NAME)
				region := test_structure.LoadString(t, exampleDir, KEY_REGION)
				az := test_structure.LoadString(t, exampleDir, KEY_AZ)
				name := test_structure.LoadString(t, exampleDir, KEY_NAME)
				terraformOptions := createTerratestOptionsForHttpLoadBalancer(exampleDir, projectId, region, az, name, domainName, MANAGED_ZONE_NAME_FOR_TEST, testCase.createDomain, testCase.enableSsl, testCase.enableHttp)
				test_structure.SaveTerraformOptions(t, exampleDir, terraformOptions)

				terraform.InitAndApply(t, terraformOptions)
			})

			test_structure.RunTestStage(t, "http_tests", func() {

				logger.Logf(t, "Running web tests by calling the created website")

				domainName := test_structure.LoadString(t, exampleDir, KEY_DOMAIN_NAME)

				if !testCase.createDomain {
					terraformOptions := test_structure.LoadTerraformOptions(t, exampleDir)
					domainName = terraform.Output(t, terraformOptions, OUTPUT_LB_IP)
				}

				expectedIndexBody := "Hello, World!"
				expectedApiBody := "Hello, api!"
				expectedNotFoundBody := "Uh oh"

				if testCase.enableHttp {
					testWebsite(t, "http", domainName, "", 200, expectedIndexBody)
					testWebsite(t, "http", domainName, "/api", 200, expectedApiBody)
					testWebsite(t, "http", domainName, "/bogus", 404, expectedNotFoundBody)
				}

				if testCase.enableSsl {
					testWebsite(t, "https", domainName, "", 200, expectedIndexBody)
					testWebsite(t, "https", domainName, "/api", 200, expectedApiBody)
					testWebsite(t, "https", domainName, "/bogus", 404, expectedNotFoundBody)
				}
			})

		})
	}
}

func testWebsite(t *testing.T, protocol string, url string, path string, expectedStatus int, expectedBody string) {
	finalUrl := fmt.Sprintf("%s://%s%s", protocol, url, path)
	// Go seems to cache the DNS results quite heavily, so we'll add
	// a lot of time to survive that
	err := HttpGetWithRetryE(t, finalUrl, expectedStatus, expectedBody, 30, 30*time.Second)
	assert.NoError(t, err, "Failed to call URL %s", url)
}

func createTerratestOptionsForHttpLoadBalancer(exampleDir string, projectId string, region string, zone string, name string, domainName string, dnsZoneName string, createDnsEntry bool, enableSsl bool, enableHttp bool) *terraform.Options {

	terratestOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: exampleDir,
		Vars: map[string]interface{}{
			"project":               projectId,
			"name":                  name,
			"region":                region,
			"custom_domain_name":    domainName,
			"create_dns_entry":      createDnsEntry,
			"dns_managed_zone_name": dnsZoneName,
			"force_destroy_website": "true",
			"enable_ssl":            enableSsl,
			"enable_http":           enableHttp,
			"zone":                  zone,
		},
	}

	return terratestOptions
}
