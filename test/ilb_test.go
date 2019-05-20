package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"path/filepath"
	"strings"
	"testing"
)

const OUTPUT_PROXY_IP = "proxy_public_ip_address"

const EXAMPLE_NAME_ILB = "internal-load-balancer"

func TestInternalLoadBalancer(t *testing.T) {
	t.Parallel()

	// We're only executing a single test but to make it easier to add further tests in future,
	// we're keeping the testcases struct
	var testcases = []struct {
		testName string
	}{
		{
			"TestILBWithProxy",
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

			_examplesDir := test_structure.CopyTerraformFolderToTemp(t, "../", "examples")
			exampleDir := filepath.Join(_examplesDir, EXAMPLE_NAME_ILB)

			test_structure.RunTestStage(t, "bootstrap", func() {
				logger.Logf(t, "Bootstrapping variables")

				projectId := gcp.GetGoogleProjectIDFromEnvVar(t)
				region := getRandomRegion(t, projectId)
				zone := gcp.GetRandomZoneForRegion(t, projectId, region)
				randomId := strings.ToLower(random.UniqueId())
				name := fmt.Sprintf("%s-%s", EXAMPLE_NAME_ILB, randomId)

				test_structure.SaveString(t, exampleDir, KEY_PROJECT, projectId)
				test_structure.SaveString(t, exampleDir, KEY_REGION, region)
				test_structure.SaveString(t, exampleDir, KEY_ZONE, zone)
				test_structure.SaveString(t, exampleDir, KEY_NAME, name)
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
				region := test_structure.LoadString(t, exampleDir, KEY_REGION)
				zone := test_structure.LoadString(t, exampleDir, KEY_ZONE)
				name := test_structure.LoadString(t, exampleDir, KEY_NAME)
				terraformOptions := createTerratestOptionsForInternalLoadBalancer(exampleDir, projectId, region, zone, name)
				test_structure.SaveTerraformOptions(t, exampleDir, terraformOptions)

				terraform.InitAndApply(t, terraformOptions)
			})

			test_structure.RunTestStage(t, "http_tests", func() {

				logger.Logf(t, "Running http tests by calling the proxy")

				terraformOptions := test_structure.LoadTerraformOptions(t, exampleDir)
				proxyIp := terraform.Output(t, terraformOptions, OUTPUT_PROXY_IP)
				proxyIp = fmt.Sprintf("%s:%s", proxyIp, "5000")

				expectedBody := "Hello, api!"

				VerifyResponse(t, "http", proxyIp, "/nameproxy", 200, expectedBody)
				VerifyResponse(t, "http", proxyIp, "/ipproxy", 200, expectedBody)
			})
		})
	}
}

func createTerratestOptionsForInternalLoadBalancer(exampleDir string, projectId string, region string, zone string, name string) *terraform.Options {

	terratestOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: exampleDir,
		Vars: map[string]interface{}{
			"project": projectId,
			"name":    name,
			"region":  region,
			"zone":    zone,
		},
	}

	return terratestOptions
}
