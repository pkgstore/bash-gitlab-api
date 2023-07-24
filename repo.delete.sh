#!/usr/bin/bash -e
#
# Deleting repository on GitLab.
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
  -a 'https://gitlab.com'               API URL.
  -r 'ORG/REPO_1;ORG/REPO_2'            Repository name (array).
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:r:h' opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    a)
      api="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
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

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_delete
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITLAB: DELETE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_delete() {
  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X DELETE \
      -H "Authorization: Bearer ${token}" \
      -H 'Content-Type: application/json' \
      "${api}/api/v4/projects/${repo//\//%2F}&permanently_remove=true"

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
