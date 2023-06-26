#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

## w -> u - motion
## c -> w - action
## y -> c - action

## b -> l - motion
## e -> y - motion

# motion
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'w'/'u'/g" {} \;
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'W'/'U'/g" {} \;

# action
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'c'/'w'/g" {} \;
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'C'/'w'/g" {} \;

# action 
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'y'/'c'/g" {} \;
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'Y'/'C'/g" {} \;

# motion
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'b'/'l'/g" {} \;
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'B'/'L'/g" {} \;

# motion
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'e'/'y'/g" {} \;
find autoload python test -type f -not -name 'colemakking.sh' -exec sed -i '' -E "s/'E'/'Y'/g" {} \;
