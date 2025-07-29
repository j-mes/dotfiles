# Volta (Node.js version manager)
export VOLTA_HOME="$HOME/.volta"                  # Set Volta home directory
export PATH="$VOLTA_HOME/bin:$PATH"               # Add Volta binaries to PATH

# Homebrew configuration
#export HOMEBREW_CASK_OPTS=--require-sha          # (Optional) Require SHA for Homebrew casks
export HOMEBREW_NO_INSECURE_REDIRECT=1            # Prevent insecure redirects in Homebrew
export PATH=/opt/homebrew/bin:$PATH               # Add Homebrew binaries to PATH
export PATH=/opt/homebrew/sbin:$PATH              # Add Homebrew sbin to PATH

# Rust
export PATH=$HOME/.cargo/bin:$PATH                # Add Rust (cargo) binaries to PATH

# Node.js project binaries
export PATH=node_modules/.bin:$PATH               # Add local node_modules binaries to PATH
