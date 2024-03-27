# terraform-aws-sns-to-teams

<a name="readme-top"></a>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

.../...

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

* AWS
* Terraform

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

.../...

### Prerequisites

.../...

### Installation

.../...

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

In your main.tf just add this lines :

```sh
module "sns_to_teams_1" {
  source                = "github.com/frolly/terraform-aws-sns-to-teams"
  entity                = var.entity
  project               = var.project
  environment           = var.environment
  application           = var.application
  owner                 = var.owner
  created_by            = var.created_by
  tf                    = var.tf
  default_region        = var.default_region
  lambda_python_version = var.lambda_python_version
  url_teams_webhook     = var.url_teams_webhook
  consigne_title        = var.consigne_title
  consigne_url          = var.consigne_url
  debug                 = var.debug
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Your idea are welcome...

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

.../...

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

.../...

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

.../...

<p align="right">(<a href="#readme-top">back to top</a>)</p>
