# Automated Resume CI/CD Pipeline (LaTeX to PDF & Web)

This repository implements a fully automated **CI/CD pipeline** that treats a resume as code. Whenever the source files are updated, GitHub Actions compiles the LaTeX documents into a polished PDF and an optimized HTML/CSS web version, then automatically deploys the website to a remote VPS using Ansible.

This project complements the [my-vps](https://github.com/HugooVer/my-vps) infrastructure repository.

## 🛠️ Tech Stack

- **CI/CD Automation:** GitHub Actions (Workflows, Custom Actions & Secrets)
- **Configuration Management / CD:** Ansible
- **Document Compilation:** LaTeX, Bash Scripting
- **Web Technologies:** HTML5, CSS3

## 🏗️ Pipeline Architecture

The workflow is orchestrated via `.github/workflows/pipeline.yml` and broken down into two distinct local custom actions:

1. **Build Stage (`.github/actions/build_files`)**:
   - Executes local automated shell scripts (`CLI_pdf_creation.sh` & `CLI_html_css_creation.sh`).
   - Compiles the source LaTeX files (`cv.tex`, `cv_en.tex`) into full production-ready PDFs containing complete details for recruiters.
   - Leverages **GitHub Actions Secrets** to dynamically mask personal sensitive details, generating a strictly anonymized HTML version for the public web.

2. **Deploy Stage (`.github/actions/deploy_ansible`)**:
   - Triggers an Ansible playbook (`ansible/playbook.yml`).
   - Securely authenticates and deploys the newly generated anonymized web assets straight to the target Nginx server container hosted on the VPS.