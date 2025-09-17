# ---------------------------------------------------------------------------
# Machine / host specific initialisation.
# This is a good place for items that may differ between environments or that
# are optional (VS Code integration, local PATH tweaks, host-based exports, etc.)
# Safe to commit; guards should prevent noisy errors on systems missing tools.
# ---------------------------------------------------------------------------

# VS Code shell integration (enables command decorations, scroll markers, etc.)
# Loaded only when inside the VS Code integrated terminal AND the 'code' CLI exists.
if [[ "$TERM_PROGRAM" == "vscode" ]] && command -v code >/dev/null 2>&1; then
	_vsc_integration_path="$(code --locate-shell-integration-path zsh 2>/dev/null)"
	if [[ -n "$_vsc_integration_path" && -f "$_vsc_integration_path" ]]; then
		source "$_vsc_integration_path"
	fi
	unset _vsc_integration_path
fi

# Example: host-based conditional (uncomment & adapt as needed)
# case "$(hostname)" in
#   work-mac*) export NODE_ENV=development ;;
#   personal-mac*) export NODE_ENV=personal ;;
# esac

# Add any per-machine overrides below this line.
