# terraform-examples

This is a repository for both simple and more complex Terraform examples. The purpose is to help build up a set of sample code that can be mixed and matched to create infrastructure, or to just help people learn more about how to use Terraform in a practical manner.

Each example should either be:

 * very simple so as to make it as understandable as possible and leave it open enough for someone to use as boilerplate and extend for their own usage.
 * build upon a previous example to show how to do something more complicated, but with the simpler versions as references
 * Documented with comments where something may be confusing

Examples can contain more than required for the exact topic, but additional resources should have comments to show that they are not required
Examples should **NOT** use modules or shortcuts unless the purpose of the example is to demonstrate modules or shortcuts!

**NOTE** : these are all examples. As such, the resulting resources may not be properly secured or configured! If using any examples as a basis for real work, please make sure you understand and impliment security and additional configuration for them!

## Contributing

Contributions are welcome, but please stay within the spirit of the repository. All examples should be tested and working. If any other steps beyond 'terraform init' and 'terraform apply' are required, then the steps should be fully documented so a beginner can follow them. If too many steps are required, or other scripts need to be run, then please be aware that the contribution may be rejected.
