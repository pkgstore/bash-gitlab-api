#!/usr/bin/env -S bash -e
#
# Updating repository on GitLab.
#
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @copyright  2023 iHub TO
# @license    MIT
# @version    0.0.1
# @link       https://lib.onl
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
  -d 'DESCRIPTION'                      Repository description.
  -v 'PRIVATE / INTERNAL / PUBLIC'      Repository visibility level (private, internal, or public).
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:r:d:v:h' opt; do
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
    d)
      description="${OPTARG}"
      ;;
    v)
      visibility="${OPTARG}"
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
  repo_update
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITLAB: UPDATE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_update() {
  [[ -z "${visibility}" ]] && visibility='public'

  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X PUT \
      -H "Authorization: Bearer ${token}" \
      -H 'Content-Type: application/json' \
      "${api}/api/v4/projects/${repo//\//%2F}" \
      -d @- << EOF
{
  "name": "${repo#*/}",
  "path": "${repo#*/}",
  "description": "${description}",
  "visibility": "${visibility}"
}
EOF

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
