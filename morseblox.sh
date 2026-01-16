#!/bin/bash

DOT_HOLD=0.26
DASH_HOLD=0.33
BETWEEN_SYMBOLS=0.23
LETTER_FREEZE=1.05
WORD_PAUSE=1.3

declare -A morse=(
    [A]=".-" [B]="-..." [C]="-.-." [D]="-.." [E]="." [F]="..-." [G]="--."
    [H]="...." [I]=".." [J]=".---" [K]="-.-" [L]=".-.." [M]="--" [N]="-."
    [O]="---" [P]=".--." [Q]="--.-" [R]=".-." [S]="..." [T]="-"
    [U]="..-" [V]="...-" [W]=".--" [X]="-..-" [Y]="-.--" [Z]="--.."
    [0]="-----" [1]=".----" [2]="..---" [3]="...--" [4]="....-"
    [5]="....." [6]="-...." [7]="--..." [8]="---.." [9]="----."
)

DASH_STATE_FILE="/tmp/morse_dash_state"
if [ -f "$DASH_STATE_FILE" ]; then
    CURRENT_DASH=$(cat "$DASH_STATE_FILE")
else
    if [ $((RANDOM % 2)) -eq 0 ]; then
        CURRENT_DASH="a"
    else
        CURRENT_DASH="d"
    fi
    echo "$CURRENT_DASH" > "$DASH_STATE_FILE"
fi

send_dot() {
    xdotool keydown space
    sleep $DOT_HOLD
    xdotool keyup space
}

send_dash() {
    xdotool keydown $CURRENT_DASH
    sleep $DASH_HOLD
    xdotool keyup $CURRENT_DASH
    
    if [ "$CURRENT_DASH" = "a" ]; then
        CURRENT_DASH="d"
    else
        CURRENT_DASH="a"
    fi
    echo "$CURRENT_DASH" > "$DASH_STATE_FILE"
}

send_letter() {
    local pattern="$1"
    local letter="$2"
    
    echo -n "Sending '${letter}': "
    for (( j=0; j<${#pattern}; j++ )); do
        echo -n "${pattern:j:1}"
    done
    echo ""
    
    for (( j=0; j<${#pattern}; j++ )); do
        case "${pattern:j:1}" in
            ".") 
                echo -n "  [JUMP] "
                send_dot 
                ;;
            "-") 
                echo -n "  [SIDESTEP with $CURRENT_DASH] "
                send_dash 
                ;;
        esac
        
        if [ $j -lt $((${#pattern}-1)) ]; then
            sleep $BETWEEN_SYMBOLS
        fi
    done
    
    echo "  [FREEZE 1s]"
    sleep $LETTER_FREEZE
}

echo "========================================"
echo "Roblox Morse Code Sender - RELIABLE"
echo "ADJUSTED: Longer delays for Roblox input"
echo "========================================"
echo "Timing: Dot=${DOT_HOLD}s, Dash=${DASH_HOLD}s, Between=${BETWEEN_SYMBOLS}s"
echo "Starting dash key: $CURRENT_DASH"
echo ""

if [ $# -gt 0 ]; then
    message="$*"
else
    read -p "Message: " message
fi

message=$(echo "$message" | tr '[:lower:]' '[:upper:]')
echo "Processing: '$message'"
echo ""

echo "Starting in 3 seconds... FOCUS ROBLOX WINDOW NOW!"
for i in {3..1}; do
    echo -n "$i... "
    sleep 1
done
echo "GO!"
echo ""

while IFS= read -r -n1 char; do
    [ -z "$char" ] && continue
    
    if [ "$char" = " " ]; then
        echo "[WORD PAUSE ${WORD_PAUSE}s]"
        sleep $WORD_PAUSE
        continue
    fi
    
    if [[ ! "$char" =~ [A-Z0-9] ]]; then
        echo "Skipping punctuation: '$char'"
        continue
    fi
    
    if [[ -n "${morse[$char]}" ]]; then
        pattern="${morse[$char]}"
        send_letter "$pattern" "$char"
    else
        echo "Skipped (not A-Z or 0-9): '$char'"
    fi
done <<< "$message"

echo ""
echo "========================================"
echo "Message complete!"
echo "Next dash will use: $CURRENT_DASH"
echo "========================================"
