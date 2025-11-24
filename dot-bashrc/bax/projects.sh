#!/bin/bash
# --------------------------------------------------------------
#                     hanoi projects
# --------------------------------------------------------------
if [[ -f .project.sh ]]; then
    source .project.sh
fi

if [[ -f .project-untracked.sh ]]; then
    source .project-untracked.sh
fi