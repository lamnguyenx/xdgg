#!/bin/bash
# --------------------------------------------------------------
#                           docker
# --------------------------------------------------------------
alias dc="docker-compose"






slugify_docker() {
    local image_name="$1"

    # Replace problematic characters but keep structure recognizable
    # Replace '/' with '_' and ':' with '__'
    local slug=$(echo "$image_name" | sed 's|/|_|g' | sed 's|:|__|g')

    echo "$slug"
}


# DOCKER
function enter() {
    local container_id="$1"
    docker exec -it $container_id bash || docker exec -it $container_id sh
}

function dcl() {
    $DC logs --no-log-prefix -f --tail 100 $@
}

function hotloadl() {
    $DC kill $@ && \
    $DC up -d --no-deps --force-recreate $@ && \
    $DC logs --no-log-prefix -f --tail 100 $@
}

function hotload ()
{
    local pattern="^$1$"

    # Get all services from docker-compose
    local all_services=$(docker-compose config --services)

    # Filter services based on pattern
    local matched_services=()
    for service in $all_services; do
        if [[ $service =~ $pattern ]]; then
            matched_services+=("$service")
        fi
    done

    # Check if any services matched
    if [ ${#matched_services[@]} -eq 0 ]; then
        echo "No services matched pattern: $pattern"
        return 1
    fi

    # Display which services will be restarted
    echo "Restarting services: ${matched_services[*]}"

    # Restart the matched services
    docker-compose kill "${matched_services[@]}" && \
    docker-compose up -d --no-deps --force-recreate "${matched_services[@]}" && \
    docker-compose logs -f "${matched_services[@]}"
}

function coldload ()
{
    local pattern="^$1$"

    # Get all services from docker-compose
    local all_services=$(docker-compose config --services)

    # Filter services based on pattern
    local matched_services=()
    for service in $all_services; do
        if [[ $service =~ $pattern ]]; then
            matched_services+=("$service")
        fi
    done

    # Check if any services matched
    if [ ${#matched_services[@]} -eq 0 ]; then
        echo "No services matched pattern: $pattern"
        return 1
    fi

    # Display which services will be restarted
    echo "Restarting services: ${matched_services[*]}"

    # Restart the matched services
    docker-compose up -d "${matched_services[@]}" && \
    docker-compose logs -f "${matched_services[@]}"
}

function hotkill ()
{
    local pattern="^$1$"

    # Get all services from docker-compose
    local all_services=$(docker-compose config --services)

    # Filter services based on pattern
    local matched_services=()
    for service in $all_services; do
        if [[ $service =~ $pattern ]]; then
            matched_services+=("$service")
        fi
    done

    # Check if any services matched
    if [ ${#matched_services[@]} -eq 0 ]; then
        echo "No services matched pattern: $pattern"
        return 1
    fi

    # Display which services will be killed
    echo "Killing services: ${matched_services[*]}"

    # Kill the matched services
    docker-compose kill "${matched_services[@]}"
}


function hotlogs ()
{
    local pattern="^$1$"

    # Get all services from docker-compose
    local all_services=$(docker-compose config --services)

    # Filter services based on pattern
    local matched_services=()
    for service in $all_services; do
        if [[ $service =~ $pattern ]]; then
            matched_services+=("$service")
        fi
    done

    # Check if any services matched
    if [ ${#matched_services[@]} -eq 0 ]; then
        echo "No services matched pattern: $pattern"
        return 1
    fi

    # Display which services will be killed
    echo "Logging services: ${matched_services[*]}"

    # Kill the matched services
    docker-compose logs -f --tail 500 "${matched_services[@]}"
}


function get_dockerfile_content() {
    # Check argument count
    if [[ $# -ne 1 ]]; then
        echo "Usage: get_dockerfile <image_name>" >&2
        return 1
    fi

    local image="$1"

    # Check if image exists
    if ! docker image inspect "$image" &>/dev/null; then
        echo "Error: Image '$image' not found" >&2
        return 1
    fi

    docker history --no-trunc "$image" \
        | tac \
        | tr -s ' ' \
        | cut -d " " -f 5- \
        | sed 's,^/bin/sh -c #(nop) ,,g' \
        | sed 's,^/bin/sh -c,RUN,g' \
        | sed 's, && ,\n  & ,g' \
        | sed 's,\s*[0-9]*[\.]*[0-9]*\s*[kMG]*B\s*$,,g' \
        | head -n -1
}

function send_docker_image_via_pipe() {
    local image_name="$1"
    local server_alias="$2"

    # Check arguments
    if [[ -z "$image_name" || -z "$server_alias" ]]; then
        echo "Usage: send_docker_image <image_name> <server_alias>"
        echo "Example: send_docker_image nginx:latest dev-server"
        return 1
    fi

    # Check if image exists locally
    if ! docker image inspect "$image_name" >/dev/null 2>&1; then
        echo "❌ Image '$image_name' not found locally"
        return 1
    fi

    # Test SSH connection
    if ! ssh -o ConnectTimeout=5 "$server_alias" "echo 'OK'" >/dev/null 2>&1; then
        echo "❌ Cannot connect to $server_alias"
        return 1
    fi

    echo "📦 Sending $image_name to $server_alias..."

    # Get image size for progress bar
    local image_size=$(docker image inspect "$image_name" --format='{{.Size}}')

    # Send with compression and progress
    docker save "$image_name" | \
    pv -s "$image_size" | \
    gzip | \
    ssh "$server_alias" 'gunzip | docker load'

    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully sent $image_name to $server_alias"
    else
        echo "❌ Transfer failed"
        return 1
    fi
}


function dc_replace_tag() {
    # Define options as variables (dry run disabled by default)
    local dry=false
    local live=false

    # Define help message with proper indentation
    local help_message="\
    Usage: dc_replace_tag [options] <source_string> <target_string>

    Tag Docker images with new tags based on existing image names in docker-compose.

    Options:
        --dry [true|false]      Show what would be tagged without actually tagging (default: false)
                                Can be used as flag: --dry (same as --dry true)
        --live [true|false]     Check only running services, not all configured (default: false)
                                Can be used as flag: --live (same as --live true)
        --config <file>         Load options from config file
        --help|-h               Show this help message

    Arguments:
        source_string           String to search for in image names
        target_string           String to replace with for new tags

    Examples:
        dc_replace_tag v1.0.0 v1.1.0
        dc_replace_tag --dry v1.0.0 v1.1.0
        dc_replace_tag --dry true v1.0.0 v1.1.0
        dc_replace_tag v1.0.0 v1.1.0 --dry
        dc_replace_tag --live --dry v1.0.0 v1.1.0
        dc_replace_tag --config my-config.sh v1.0.0 v1.1.0

    Config file example:
        dry=true
        live=false
    "

    # Store original arguments for processing
    local -a original_args=("$@")

    # Parse arguments
    parse_args "${original_args[@]}" || {
        printf "%s\n" "$help_message" >&2
        return 1
    }

    # After parse_args, we need to get the remaining positional arguments
    # We'll reprocess to extract them
    local -a positional_args=()
    local skip_next=false

    for arg in "${original_args[@]}"; do
        if [[ $skip_next == true ]]; then
            skip_next=false
            continue
        fi

        case $arg in
            --dry)
                if [[ ${original_args[*]} =~ --dry[[:space:]]+(true|false) ]]; then
                    skip_next=true
                fi
                ;;
            --live)
                if [[ ${original_args[*]} =~ --live[[:space:]]+(true|false) ]]; then
                    skip_next=true
                fi
                ;;
            --config)
                skip_next=true
                ;;
            --help|-h)
                ;;
            --*)
                ;;
            *)
                positional_args+=("$arg")
                ;;
        esac
    done

    # Get remaining arguments (source and target strings)
    local source_string="${positional_args[0]}"
    local target_string="${positional_args[1]}"

    # Validate required arguments - show help if missing
    if [ -z "$source_string" ] || [ -z "$target_string" ]; then
        printf "%s\n" "$help_message" >&2
        return 1
    fi

    # Get list of images based on mode
    local images_list=""
    if [ "$live" = "true" ]; then
        echo "=== Checking running services ==="
        images_list=$(docker-compose ps --format "table {{.Service}}\t{{.Image}}" \
            | tail -n +2)
    else
        echo "=== Checking all configured services ==="
        images_list=$(docker-compose config \
            | grep -E '^\s*image:' \
            | sed 's/.*image: //' \
            | sort \
            | uniq \
            | awk '{print "service\t" $0}')
    fi

    # Filter images that contain the source string
    local matching_images=$(echo "$images_list" \
        | grep "$source_string")

    if [ -z "$matching_images" ]; then
        echo "No images found containing: $source_string"
        return 0
    fi

    # Always show dry run first (preview)
    echo ""
    echo "--------------------------------------------------------------"
    echo "                          dry-run"
    echo "--------------------------------------------------------------"
    echo ""
    echo "=== Docker tag commands that would be executed ==="
    echo "$matching_images" \
        | while read service_name image_name; do
            local new_image_name=$(echo "$image_name" | sed "s|${source_string}|${target_string}|g")
            echo "    docker tag \\"
            echo "        $image_name \\"
            echo "        $new_image_name"
            echo ""
        done

    # If dry run mode, exit after showing preview
    if [ "$dry" = "true" ]; then
        return 0
    fi

    # Ask for confirmation before proceeding
    echo ""
    echo "--------------------------------------------------------------"
    read -p "Do you want to proceed with tagging? (y/N): " -n 1 -r
    echo ""
    echo "--------------------------------------------------------------"

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        return 0
    fi

    # Actually tag the images
    echo ""
    echo "=== Tagging images ==="
    local success_count=0
    local total_count=0

    echo "$matching_images" \
        | while read service_name image_name; do
            local new_image_name=$(echo "$image_name" | sed "s|${source_string}|${target_string}|g")
            total_count=$((total_count + 1))

            echo "Tagging: $image_name -> $new_image_name"
            if docker tag "$image_name" "$new_image_name"; then
                success_count=$((success_count + 1))
                echo "    ✓ Success"
            else
                echo "    ✗ Failed"
            fi
            echo ""
        done

    echo "=== Summary ==="
    echo "Tagged images successfully"
    echo ""
    echo "=== Next steps ==="
    echo "1. Update your docker-compose.yml manually if needed"
    echo "2. Push new tags: docker push <new_image_name>"
    echo "3. Update services: docker-compose pull && docker-compose up -d"
}