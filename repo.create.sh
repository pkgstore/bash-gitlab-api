#!/usr/bin/bash -e
#
# Creating repository on GitLab.
#
# @package    Bash
# @author     Kitsune Solar <mail@kitsune.solar>
# @copyright  2023 iHub TO
# @license    MIT
# @version    0.0.1
# @link       https://github.com/pkgstore
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID == 0 )) && { echo >&2 'This script should not be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

curl="$( command -v curl )"
sleep='2'

# Help.
read -r -d '' help <<- EOF
Options:
  -x 'TOKEN'                            GitLab user token.
  -a 'https://gitlab.com'               GitLab API URL.
  -n 'NSID'                             Namespace ID for new repository.
  -r 'REPO_1;REPO_2;REPO_3'             Repository name (array).
  -d 'DESCRIPTION'                      Repository description.
  -v 'PRIVATE / INTERNAL / PUBLIC'      Repository visibility level (private, internal, or public).
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:n:r:d:v:eh' opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    a)
      api="${OPTARG}"
      ;;
    n)
      nsid="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    d)
      description="${OPTARG}"
      ;;
    v)
      visibility="${OPTARG}"
      ;;
    e)
      has_readme=1
      ;;
    h|*)
      echo "${help}"; exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) && { echo >&2 '[ERROR] Repository name not specified!'; exit 1; }
[[ -z "${token}" ]] && { echo >&2 '[ERROR] Token not specified!'; exit 1; }
[[ -z "${api}" ]] && { echo >&2 '[ERROR] GitLab API URL not specified!'; exit 1; }
[[ -z "${nsid}" ]] && { echo >&2 '[ERROR] Namespace ID not specified!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_create
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITLAB: CREATE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_create() {
  [[ -z "${visibility}" ]] && visibility='public'
  [[ -n "${has_readme}" ]] && has_readme='true' || has_readme='false'

  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X POST \
      -H "Authorization: Bearer ${token}" \
      -H 'Content-Type: application/json' \
      "${api}/api/v4/projects/" \
      -d @- << EOF
{
  "name": "${repo}",
  "path": "${repo}",
  "namespace_id": "${nsid}",
  "description": "${description}",
  "visibility": "${visibility}",
  "initialize_with_readme": "${has_readme}"
}
EOF

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
