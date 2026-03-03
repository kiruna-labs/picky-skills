#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS=("picky-design" "picky-security" "picky-tester" "picky-performance" "picky-landingpage")
AGENTS=("picky-design" "picky-security" "picky-tester" "picky-performance" "picky-orchestrator")

echo "🔍 Picky Skills Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

install_agents() {
    local target_dir="$1"
    local label="$2"
    mkdir -p "$target_dir"
    local count=0
    for agent in "${AGENTS[@]}"; do
        local src="$SCRIPT_DIR/$agent/agent.md"
        if [ -f "$src" ]; then
            rm -f "$target_dir/$agent.md"
            ln -sf "$src" "$target_dir/$agent.md"
            count=$((count + 1))
        fi
    done
    # landingpage has SKILL.md but may not have agent.md yet
    if [ -f "$SCRIPT_DIR/picky-landingpage/agent.md" ]; then
        rm -f "$target_dir/picky-landingpage.md"
        ln -sf "$SCRIPT_DIR/picky-landingpage/agent.md" "$target_dir/picky-landingpage.md"
        count=$((count + 1))
    fi
    echo "  ✅ Installed $count agents for $label → $target_dir"
}

install_skills() {
    local target_dir="$1"
    local label="$2"
    mkdir -p "$target_dir"
    local count=0
    for skill in "${SKILLS[@]}"; do
        if [ -d "$SCRIPT_DIR/$skill" ]; then
            rm -rf "$target_dir/$skill"
            ln -sf "$SCRIPT_DIR/$skill" "$target_dir/$skill"
            count=$((count + 1))
        fi
    done
    echo "  ✅ Installed $count skills for $label → $target_dir"
}

# Detect what's available
HAS_CLAUDE=false
HAS_CURSOR=false
HAS_KIRO=false

[ -d "$HOME/.claude" ] || command -v claude &>/dev/null 2>&1 && HAS_CLAUDE=true
[ -d "$HOME/.cursor" ] && HAS_CURSOR=true
[ -d "$HOME/.kiro" ] && HAS_KIRO=true

echo "Choose installation mode:"
echo ""
echo "  1) Subagents — isolated context, read-only enforced (recommended)"
echo "  2) Skills — injected into main conversation context"
echo "  3) Both"
echo ""
read -p "Choose [1/2/3]: " mode

echo ""

case $mode in
    1|3)
        if $HAS_CLAUDE; then
            echo "📦 Claude Code agents..."
            install_agents "$HOME/.claude/agents" "Claude Code"
        fi
        if [ -d ".claude" ]; then
            echo "📦 Project-level agents..."
            install_agents ".claude/agents" "Project"
        fi
        ;;
esac

case $mode in
    2|3)
        if $HAS_CLAUDE; then
            echo "📦 Claude Code skills..."
            install_skills "$HOME/.claude/skills" "Claude Code"
        fi
        if $HAS_CURSOR; then
            echo "📦 Cursor skills..."
            install_skills "$HOME/.cursor/skills" "Cursor"
        fi
        if $HAS_KIRO; then
            echo "📦 Kiro skills..."
            install_skills "$HOME/.kiro/skills" "Kiro"
        fi
        ;;
esac

if ! $HAS_CLAUDE && ! $HAS_CURSOR && ! $HAS_KIRO; then
    echo "No agents detected. Installing to Claude Code defaults..."
    if [ "$mode" = "2" ] || [ "$mode" = "3" ]; then
        install_skills "$HOME/.claude/skills" "Claude Code"
    fi
    if [ "$mode" = "1" ] || [ "$mode" = "3" ]; then
        install_agents "$HOME/.claude/agents" "Claude Code"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Done! Try: \"Run a picky security audit\" in your agent."
