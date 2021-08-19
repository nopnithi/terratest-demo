package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSimpleWebApp(t *testing.T) {
	t.Parallel()
	// Terraform options to handle the most common retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Path where Terraform code is located
		TerraformDir: "../terraform",
	})
	// Run "terraform destroy" to clean up at the end of test
	defer terraform.Destroy(t, terraformOptions)
	// Run "terraform init" and "terraform apply"
	terraform.InitAndApply(t, terraformOptions)
	// Run "terraform output" to get the values from Terraform
	webUrl := terraform.Output(t, terraformOptions, "web_url")
	webBody := terraform.Output(t, terraformOptions, "web_body")
	// Send an HTTP request to web app and make sure to get back HTTP body and response code as 200
	http_helper.HttpGetWithRetry(t, webUrl, nil, 200, webBody, 30, 5*time.Second)
}
