#!/bin/bash

# Adalyst MCP Collection - Auto Installer
# Supports macOS and Linux
# Handles Python 3.11, UV, dependencies, and Claude Desktop configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fancy banner
echo -e "${PURPLE}"
echo "    ___       __      __           __ "
echo "   /   | ____/ /___ _/ /_  _______/ /_"
echo "  / /| |/ __  / __ \`/ / / / / ___/ __/"
echo " / ___ / /_/ / /_/ / / /_/ (__  ) /_  "
echo "/_/  |_\__,_/\__,_/_/\__, /____/\__/  "
echo "                   /____/             "
echo -e "${NC}"
echo -e "${CYAN}🚀 MCP Collection Installer${NC}"
echo -e "${CYAN}===========================${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux" 
    CLAUDE_CONFIG_DIR="$HOME/.config/Claude"
else
    echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
    echo "This installer supports macOS and Linux only."
    echo "For Windows, please use install.ps1"
    exit 1
fi

echo -e "${BLUE}🖥️  Detected OS: $OS${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get Python version
get_python_version() {
    if command_exists python3.11; then
        echo "python3.11"
    elif command_exists python3; then
        local version=$(python3 --version 2>&1 | grep -o '[0-9]\+\.[0-9]\+')
        if [[ "$version" == "3.11" ]]; then
            echo "python3"
        else
            echo ""
        fi
    else
        echo ""
    fi
}

echo ""
echo -e "${YELLOW}🔍 Checking system requirements...${NC}"

# Check Python 3.11
PYTHON_CMD=$(get_python_version)
if [[ -z "$PYTHON_CMD" ]]; then
    echo -e "${RED}❌ Python 3.11 not found${NC}"
    echo ""
    echo -e "${YELLOW}📦 Installing Python 3.11...${NC}"
    
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            echo "   Using Homebrew..."
            brew install python@3.11
            PYTHON_CMD="python3.11"
        else
            echo -e "${RED}❌ Homebrew not found${NC}"
            echo ""
            echo "Please install Homebrew first:"
            echo -e "${CYAN}/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${NC}"
            echo ""
            echo "Then run this installer again."
            exit 1
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Try different package managers
        if command_exists apt; then
            echo "   Using apt..."
            sudo apt update
            sudo apt install -y python3.11 python3.11-venv python3.11-pip
            PYTHON_CMD="python3.11"
        elif command_exists yum; then
            echo "   Using yum..."
            sudo yum install -y python3.11 python3.11-venv python3.11-pip
            PYTHON_CMD="python3.11"
        elif command_exists pacman; then
            echo "   Using pacman..."
            sudo pacman -S python python-pip
            PYTHON_CMD="python3"
        else
            echo -e "${RED}❌ No supported package manager found${NC}"
            echo "Please install Python 3.11 manually and run this installer again."
            exit 1
        fi
    fi
else
    echo -e "${GREEN}✅ Python 3.11 found: $PYTHON_CMD${NC}"
fi

# Verify Python installation
if ! $PYTHON_CMD --version >/dev/null 2>&1; then
    echo -e "${RED}❌ Python installation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Python version: $($PYTHON_CMD --version)${NC}"

# Check UV
if ! command_exists uv; then
    echo -e "${YELLOW}📦 Installing UV (modern Python package manager)...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add UV to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
    
    if ! command_exists uv; then
        echo -e "${RED}❌ UV installation failed${NC}"
        echo "Please restart your terminal and run this installer again."
        exit 1
    fi
else
    echo -e "${GREEN}✅ UV found${NC}"
fi

# Check Claude Desktop
echo ""
echo -e "${YELLOW}🔍 Checking Claude Desktop...${NC}"
if [[ "$OS" == "macos" ]]; then
    if [[ ! -d "/Applications/Claude.app" ]]; then
        echo -e "${YELLOW}⚠️  Claude Desktop not found in Applications${NC}"
        echo ""
        echo -e "${CYAN}Please download and install Claude Desktop:${NC}"
        echo -e "${CYAN}https://claude.ai/download${NC}"
        echo ""
        read -p "Press Enter after installing Claude Desktop..."
    fi
elif [[ "$OS" == "linux" ]]; then
    echo -e "${BLUE}ℹ️  Make sure Claude Desktop is installed${NC}"
    echo -e "${CYAN}Download from: https://claude.ai/download${NC}"
fi

echo -e "${GREEN}✅ Claude Desktop check complete${NC}"

# Create working directory
INSTALL_DIR="$HOME/.adalyst-mcp"
echo ""
echo -e "${YELLOW}📁 Creating installation directory...${NC}"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✅ Created: $INSTALL_DIR${NC}"

# Show available MCP servers
echo ""
echo -e "${CYAN}🛠️  Available MCP Servers:${NC}"
echo ""
echo -e "${GREEN}1.${NC} Meta Competitor Research"
echo -e "   ${BLUE}Analyze Facebook/Instagram competitor ads${NC}"
echo -e "   ${BLUE}• Creative strategy analysis${NC}"
echo -e "   ${BLUE}• Batch competitor comparison${NC}"
echo -e "   ${BLUE}• AI-powered image/video insights${NC}"
echo ""

# For now, just install Meta Competitor Research
echo -e "${YELLOW}🚀 Installing Meta Competitor Research...${NC}"
echo ""

SERVER_DIR="$INSTALL_DIR/meta-competitor-research-mcp"
mkdir -p "$SERVER_DIR"

# Download the server files
echo -e "${YELLOW}📥 Downloading server files...${NC}"

# Check if we're in the git repo (development) or downloading from GitHub (production)
if [[ -f "./mcp_server.py" ]]; then
    echo "   Using local files (running from server directory)"
    # Copy all files including hidden files, excluding problematic directories
    cp -r . "$SERVER_DIR/"
    # Remove any nested installation directories that might have been copied
    rm -rf "$SERVER_DIR/.venv" "$SERVER_DIR/.adalyst-mcp" 2>/dev/null || true
elif [[ -f "./meta-competitor-research-mcp/mcp_server.py" ]]; then
    echo "   Using local files (running from parent directory)"
    cp -r ./meta-competitor-research-mcp/. "$SERVER_DIR/"
    # Remove any nested installation directories that might have been copied  
    rm -rf "$SERVER_DIR/.venv" "$SERVER_DIR/.adalyst-mcp" 2>/dev/null || true
else
    echo "   Downloading from GitHub..."
    # Download files from GitHub
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/mcp_server.py" -o "$SERVER_DIR/mcp_server.py"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/requirements.txt" -o "$SERVER_DIR/requirements.txt"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/env.template" -o "$SERVER_DIR/env.template"
    
    # Create src directory and download service files
    mkdir -p "$SERVER_DIR/src/services"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/src/services/scrapecreators_service.py" -o "$SERVER_DIR/src/services/scrapecreators_service.py"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/src/services/media_cache_service.py" -o "$SERVER_DIR/src/services/media_cache_service.py"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/src/services/gemini_service.py" -o "$SERVER_DIR/src/services/gemini_service.py"
    curl -fsSL "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp/src/logger.py" -o "$SERVER_DIR/src/logger.py"
fi

echo -e "${GREEN}✅ Server files downloaded${NC}"

# Create virtual environment with UV
echo -e "${YELLOW}🐍 Creating virtual environment...${NC}"
cd "$SERVER_DIR"
uv venv --python "$PYTHON_CMD"
echo -e "${GREEN}✅ Virtual environment created${NC}"

# Install dependencies
echo -e "${YELLOW}📚 Installing dependencies...${NC}"
uv pip install -r requirements.txt
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Configure API keys
echo ""
echo -e "${CYAN}🔑 API Key Configuration${NC}"
echo -e "${CYAN}========================${NC}"
echo ""

if [[ ! -f ".env" ]]; then
    cp env.template .env
fi

echo -e "${BLUE}For Meta Competitor Research, you need:${NC}"
echo ""
echo -e "${YELLOW}1. ScrapeCreators API Key (Required)${NC}"
echo -e "   ${CYAN}• Sign up at: https://scrapecreators.com/${NC}"
echo -e "   ${CYAN}• Get your API key from the dashboard${NC}"
echo ""
echo -e "${YELLOW}2. Google Gemini API Key (Optional - for video analysis)${NC}"
echo -e "   ${CYAN}• Get yours at: https://aistudio.google.com/app/apikey${NC}"
echo ""

# Get ScrapeCreators API key
while true; do
    echo -e "${GREEN}Please enter your ScrapeCreators API key:${NC}"
    read -r SCRAPECREATORS_API_KEY
    
    if [[ -n "$SCRAPECREATORS_API_KEY" ]]; then
        # Update .env file
        if [[ "$OS" == "macos" ]]; then
            sed -i '' "s/SCRAPECREATORS_API_KEY=.*/SCRAPECREATORS_API_KEY=$SCRAPECREATORS_API_KEY/" .env
        else
            sed -i "s/SCRAPECREATORS_API_KEY=.*/SCRAPECREATORS_API_KEY=$SCRAPECREATORS_API_KEY/" .env
        fi
        echo -e "${GREEN}✅ ScrapeCreators API key configured${NC}"
        break
    else
        echo -e "${RED}❌ API key cannot be empty${NC}"
    fi
done

# Get Gemini API key (optional)
echo ""
echo -e "${GREEN}Enter your Google Gemini API key (press Enter to skip):${NC}"
read -r GEMINI_API_KEY

if [[ -n "$GEMINI_API_KEY" ]]; then
    if [[ "$OS" == "macos" ]]; then
        sed -i '' "s/GEMINI_API_KEY=.*/GEMINI_API_KEY=$GEMINI_API_KEY/" .env
    else
        sed -i "s/GEMINI_API_KEY=.*/GEMINI_API_KEY=$GEMINI_API_KEY/" .env
    fi
    echo -e "${GREEN}✅ Gemini API key configured${NC}"
else
    echo -e "${YELLOW}⚠️  Skipped Gemini API key (video analysis will be disabled)${NC}"
fi

# Test the server
echo ""
echo -e "${YELLOW}🧪 Testing server installation...${NC}"

# Create a simple test script
cat > test_server.py << 'EOF'
#!/usr/bin/env python3
import sys
import subprocess
import json
import time

def test_server():
    try:
        # Start server
        proc = subprocess.Popen(
            [sys.executable, "mcp_server.py"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        time.sleep(2)
        
        if proc.poll() is None:
            # Send init request
            init_request = json.dumps({
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "0.1.0",
                    "capabilities": {},
                    "clientInfo": {"name": "test", "version": "1.0"}
                }
            }) + "\n"
            
            proc.stdin.write(init_request)
            proc.stdin.flush()
            
            # Try to read response
            import select
            readable, _, _ = select.select([proc.stdout], [], [], 3.0)
            
            if readable:
                response = proc.stdout.readline()
                if response:
                    data = json.loads(response)
                    if 'result' in data:
                        print("✅ Server test passed")
                        proc.terminate()
                        return True
            
            proc.terminate()
            print("❌ Server test failed - no response")
            return False
        else:
            stderr = proc.stderr.read()
            print(f"❌ Server failed to start: {stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Server test error: {e}")
        return False

if __name__ == "__main__":
    sys.exit(0 if test_server() else 1)
EOF

# Run test with UV
if .venv/bin/python test_server.py; then
    echo -e "${GREEN}✅ Server installation test passed${NC}"
else
    echo -e "${RED}❌ Server installation test failed${NC}"
    echo "Please check the error messages above."
    exit 1
fi

# Clean up test file
rm -f test_server.py

# Configure Claude Desktop
echo ""
echo -e "${YELLOW}⚙️  Configuring Claude Desktop...${NC}"

mkdir -p "$CLAUDE_CONFIG_DIR"
CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Get the UV Python path
UV_PYTHON_PATH="$SERVER_DIR/.venv/bin/python"
SERVER_PATH="$SERVER_DIR/mcp_server.py"

# Create or update Claude Desktop config
if [[ -f "$CONFIG_FILE" ]]; then
    echo "   Updating existing configuration..."
    
    # Backup existing config
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    
    # Use Python to update JSON config
    cat > update_config.py << EOF
import json
import sys

config_file = "$CONFIG_FILE"
try:
    with open(config_file, 'r') as f:
        config = json.load(f)
except:
    config = {}

if 'mcpServers' not in config:
    config['mcpServers'] = {}

config['mcpServers']['adalyst-meta-competitor-research'] = {
    "command": "$UV_PYTHON_PATH",
    "args": ["$SERVER_PATH"]
}

with open(config_file, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Configuration updated")
EOF

    .venv/bin/python update_config.py
    rm -f update_config.py
    
else
    echo "   Creating new configuration..."
    
    cat > "$CONFIG_FILE" << EOF
{
  "mcpServers": {
    "adalyst-meta-competitor-research": {
      "command": "$UV_PYTHON_PATH",
      "args": ["$SERVER_PATH"]
    }
  }
}
EOF
fi

echo -e "${GREEN}✅ Claude Desktop configured${NC}"

# Final instructions
echo ""
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo -e "${GREEN}======================${NC}"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1.${NC} ${BLUE}Restart Claude Desktop completely${NC}"
echo -e "   ${CYAN}• On macOS: Cmd+Q then reopen${NC}"
echo -e "   ${CYAN}• On Linux: Close and reopen${NC}"
echo ""
echo -e "${YELLOW}2.${NC} ${BLUE}Wait 10-15 seconds after restart${NC}"
echo -e "   ${CYAN}• Let Claude load the MCP servers${NC}"
echo ""
echo -e "${YELLOW}3.${NC} ${BLUE}Test your installation${NC}"
echo -e "   ${CYAN}• Ask Claude: \"What competitor research tools do you have?\"${NC}"
echo -e "   ${CYAN}• Or try: \"Search for Nike's Facebook ads\"${NC}"
echo ""
echo -e "${PURPLE}🚀 Example Queries:${NC}"
echo -e "   ${CYAN}• \"Analyze Nike vs Adidas current ad strategies\"${NC}"
echo -e "   ${CYAN}• \"What messaging themes are fitness brands using?\"${NC}"
echo -e "   ${CYAN}• \"Compare Coca-Cola and Pepsi's recent campaigns\"${NC}"
echo ""
echo -e "${GREEN}Installation directory: $SERVER_DIR${NC}"
echo -e "${GREEN}Claude config file: $CONFIG_FILE${NC}"
echo ""
echo -e "${YELLOW}Need help? Visit: https://github.com/adalyst/adalyst-mcp${NC}"
echo ""