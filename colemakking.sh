#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

## w -> u - motion
## c -> w - action
## y -> c - action

## b -> l - motion
## e -> y - motion

find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'w'/'u'/g" {} \;
find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'W'/'U'/g" {} \;

find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'c'/'w'/g" {} \;
find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'C'/'w'/g" {} \;

find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'y'/'c'/g" {} \;
find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'Y'/'C'/g" {} \;

find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'b'/'l'/g" {} \;
find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'B'/'L'/g" {} \;

find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'e'/'y'/g" {} \;
find . -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'E'/'Y'/g" {} \;
