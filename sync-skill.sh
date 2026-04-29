#!/bin/bash
# sync-skill.sh
# Copies the skill from this repo into Claude's skills directory.
# Run this after making edits to pick up changes in your next Claude conversation.

SKILL_DIR="/mnt/skills/user/damodaran-valuation"

echo "Syncing damodaran-valuation skill..."
cp -r damodaran-valuation/ "$SKILL_DIR/"
echo "Done. Skill updated at: $SKILL_DIR"
echo "Changes will be active in your next Claude conversation."
