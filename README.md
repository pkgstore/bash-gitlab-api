# Bash tools for GitLab API

Tools for automating work with [GitLab](https://gitlab.com/).

## Syntax

### Creating repository

- [repo.create.sh](repo.create.sh)
  - `-x 'TOKEN'`  
    GitLab user token.
  - `-a 'https://gitlab.com'`  
    GitLab API URL.
  - `-n 'NSID'`  
    Namespace ID for new repository.
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).
  - `-d 'DESCRIPTION'`  
    Repository description.
  - `-v 'PRIVATE / INTERNAL / PUBLIC'`  
    Repository visibility level (private, internal, or public).

### Deleting repository

- [repo.delete.sh](repo.delete.sh)
  - `-x 'TOKEN'`  
    GitLab user token.
  - `-a 'https://gitlab.com'`  
    GitLab API URL.
  - `-r 'ORG/REPO_1;ORG/REPO_2'`  
    Repository name (array).

### Transferring repository

- [repo.transfer.sh](repo.transfer.sh)
  - `-x 'TOKEN'`  
    GitLab user token.
  - `-a 'https://gitlab.com'`  
    GitLab API URL.
  - `-n 'NSID'`  
    NEW namespace ID for repository.
  - `-r 'REPO_1;REPO_2;REPO_3'`  
    Repository name (array).

### Updating repository

- [repo.update.sh](repo.update.sh)
  - `-x 'TOKEN'`  
    GitLab user token.
  - `-a 'https://gitlab.com'`  
    GitLab API URL.
  - `-r 'ORG/REPO_1;ORG/REPO_2'`  
    Repository name (array).
  - `-d 'DESCRIPTION'`  
    Repository description.
  - `-v 'PRIVATE / INTERNAL / PUBLIC'`  
    Repository visibility level (private, internal, or public).
