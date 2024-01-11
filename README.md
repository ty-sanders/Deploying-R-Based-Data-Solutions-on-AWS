# Deploying-R-Based-Data-Solutions-on-AWS
Template for production-ready data applications written in R and deployed via Terraform to AWS presented in person January 12 2024 including live deployment demo

This repo consists of 4 sections: 

In the root folder is a `Dockerfile` example for deploying a custom R Shiny app on a container running Shiny Server

In the app folder is a sample R Shiny app within `app.R`

In the terraform folder is a set of terraform scripts for a sample deployment of the R Shiny container to AWS App Runner within a VPC

In the presentation folder is a .pptx and .pdf version of the accompanying presentation

I hope any and all interested parties can find these sample files and deployment philosophy helpful and all are welcome to view, pull, and use any of the code above however they would wish, just be aware that this sample is not built to be a production ready worklow from a security standpoint and the deployed App Runner without changes would be globally accessable via HTTPS. 
