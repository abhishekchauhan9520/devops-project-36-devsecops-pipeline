# Project 36 — End-to-End DevSecOps CI/CD Pipeline

A production-style GitHub Actions pipeline that treats security as release gates rather than optional reporting.

## Pipeline

```text
Pull Request
    |
    +--> Unit tests
    +--> CodeQL SAST
    +--> Gitleaks secret detection
    +--> Dependency vulnerability scan
    +--> IaC security scan
    |
    +--> Build container
    +--> Trivy image scan
    +--> SBOM generation
    +--> Artifact/provenance attestation
    |
    `--> Build is promoted only when gates pass
```

## Security gates

- Unit tests and syntax checks
- CodeQL static analysis
- Gitleaks secret scanning
- Trivy filesystem/dependency scanning
- Checkov Terraform/IaC scanning
- Trivy container image scanning
- SBOM generation with Syft
- GitHub artifact attestation for container build provenance
- Least-privilege GitHub Actions permissions
- No deployment credentials stored in the workflow

## Local validation

```bash
python -m compileall app
python -m unittest discover -s tests -v
bash tests/test_structure.sh
```

The GitHub workflow is the authoritative scanner environment. It does not deploy to production.

## Design principle

A security tool should be able to fail the pipeline when its policy is violated. Informational-only scanners are deliberately avoided in this project.
