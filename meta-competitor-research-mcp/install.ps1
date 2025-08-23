# Adalyst MCP Collection - Windows Installer
# Meta Competitor Research MCP Server
# Handles Python 3.11, UV, dependencies, and Claude Desktop configuration

# Enable strict mode
$ErrorActionPreference = "Stop"

# Colors for output
$Red = "Red"
$Green = "Green" 
$Yellow = "Yellow"
$Blue = "Blue"
$Magenta = "Magenta"
$Cyan = "Cyan"

# Fancy banner
Write-Host ""
Write-Host "    ___       __      __           __ " -ForegroundColor $Magenta
Write-Host "   /   | ____/ /___ _/ /_  _______/ /_" -ForegroundColor $Magenta  
Write-Host "  / /| |/ __  / __ \`/ / / / / ___/ __/" -ForegroundColor $Magenta
Write-Host " / ___ / /_/ / /_/ / / /_/ (__  ) /_  " -ForegroundColor $Magenta
Write-Host "/_/  |_\__,_/\__,_/_/\__, /____/\__/  " -ForegroundColor $Magenta
Write-Host "                   /____/             " -ForegroundColor $Magenta
Write-Host ""
Write-Host "🚀 MCP Collection Installer (Windows)" -ForegroundColor $Cyan
Write-Host "=====================================" -ForegroundColor $Cyan
Write-Host ""

# Check Windows version
Write-Host "🖥️  Windows System Detected" -ForegroundColor $Blue

# Function to check if command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Function to get Python version
function Get-PythonVersion {
    if (Test-Command "python3.11") {
        return "python3.11"
    } elseif (Test-Command "python") {
        try {
            $version = python --version 2>&1
            if ($version -match "Python 3\.11") {
                return "python"
            }
        } catch {}
    }
    return $null
}

Write-Host ""
Write-Host "🔍 Checking system requirements..." -ForegroundColor $Yellow

# Check Python 3.11
$PythonCmd = Get-PythonVersion
if (-not $PythonCmd) {
    Write-Host "❌ Python 3.11 not found" -ForegroundColor $Red
    Write-Host ""
    Write-Host "📦 Installing Python 3.11..." -ForegroundColor $Yellow
    
    # Try winget first
    if (Test-Command "winget") {
        Write-Host "   Using winget..." -ForegroundColor $Blue
        try {
            winget install Python.Python.3.11 --exact --accept-package-agreements --accept-source-agreements
            $PythonCmd = "python"
            Write-Host "✅ Python 3.11 installed via winget" -ForegroundColor $Green
        } catch {
            Write-Host "❌ Winget installation failed" -ForegroundColor $Red
        }
    }
    
    # If winget failed or not available, provide manual instructions
    if (-not $PythonCmd) {
        Write-Host "❌ Automatic installation failed" -ForegroundColor $Red
        Write-Host ""
        Write-Host "Please install Python 3.11 manually:" -ForegroundColor $Yellow
        Write-Host "1. Visit: https://www.python.org/downloads/release/python-3118/" -ForegroundColor $Cyan
        Write-Host "2. Download 'Windows installer (64-bit)'" -ForegroundColor $Cyan
        Write-Host "3. Run installer and check 'Add Python to PATH'" -ForegroundColor $Cyan
        Write-Host "4. Restart PowerShell and run this installer again" -ForegroundColor $Cyan
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "✅ Python 3.11 found: $PythonCmd" -ForegroundColor $Green
}

# Verify Python installation
try {
    $pythonVersion = & $PythonCmd --version
    Write-Host "✅ Python version: $pythonVersion" -ForegroundColor $Green
} catch {
    Write-Host "❌ Python installation verification failed" -ForegroundColor $Red
    exit 1
}

# Check UV
if (-not (Test-Command "uv")) {
    Write-Host "📦 Installing UV (modern Python package manager)..." -ForegroundColor $Yellow
    
    try {
        # Install UV via PowerShell script
        Invoke-RestMethod -Uri "https://astral.sh/uv/install.ps1" | Invoke-Expression
        
        # Refresh PATH for current session
        $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
        
        if (-not (Test-Command "uv")) {
            Write-Host "❌ UV installation failed" -ForegroundColor $Red
            Write-Host "Please restart PowerShell and run this installer again." -ForegroundColor $Yellow
            exit 1
        }
    } catch {
        Write-Host "❌ UV installation failed: $($_.Exception.Message)" -ForegroundColor $Red
        exit 1
    }
} else {
    Write-Host "✅ UV found" -ForegroundColor $Green
}

# Check Claude Desktop
Write-Host ""
Write-Host "🔍 Checking Claude Desktop..." -ForegroundColor $Yellow

$claudeDesktopPaths = @(
    "$env:LOCALAPPDATA\Programs\Claude\Claude.exe",
    "$env:APPDATA\Claude\Claude.exe"
)

$claudeFound = $false
foreach ($path in $claudeDesktopPaths) {
    if (Test-Path $path) {
        $claudeFound = $true
        break
    }
}

if (-not $claudeFound) {
    Write-Host "⚠️  Claude Desktop not found" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "Please download and install Claude Desktop:" -ForegroundColor $Cyan
    Write-Host "https://claude.ai/download" -ForegroundColor $Cyan
    Write-Host ""
    Read-Host "Press Enter after installing Claude Desktop"
}

Write-Host "✅ Claude Desktop check complete" -ForegroundColor $Green

# Create working directory
$InstallDir = Join-Path $env:USERPROFILE ".adalyst-mcp"
Write-Host ""
Write-Host "📁 Creating installation directory..." -ForegroundColor $Yellow
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Write-Host "✅ Created: $InstallDir" -ForegroundColor $Green

# Show available MCP servers  
Write-Host ""
Write-Host "🛠️  Available MCP Servers:" -ForegroundColor $Cyan
Write-Host ""
Write-Host "1. Meta Competitor Research" -ForegroundColor $Green
Write-Host "   Analyze Facebook/Instagram competitor ads" -ForegroundColor $Blue
Write-Host "   • Creative strategy analysis" -ForegroundColor $Blue
Write-Host "   • Batch competitor comparison" -ForegroundColor $Blue
Write-Host "   • AI-powered image/video insights" -ForegroundColor $Blue
Write-Host ""

# Install Meta Competitor Research
Write-Host "🚀 Installing Meta Competitor Research..." -ForegroundColor $Yellow
Write-Host ""

$ServerDir = Join-Path $InstallDir "meta-competitor-research-mcp"
New-Item -ItemType Directory -Path $ServerDir -Force | Out-Null

# Download the server files
Write-Host "📥 Downloading server files..." -ForegroundColor $Yellow

# Check if we're in the git repo (development) or downloading from GitHub (production)
$currentDir = Get-Location
$localServer = Join-Path $currentDir "mcp_server.py"

if (Test-Path $localServer) {
    Write-Host "   Using local files (running from server directory)" -ForegroundColor $Blue
    Copy-Item -Path ".\*" -Destination $ServerDir -Recurse -Force
} else {
    # Check if running from parent directory
    $parentServer = Join-Path $currentDir "meta-competitor-research-mcp\mcp_server.py"
    if (Test-Path $parentServer) {
        Write-Host "   Using local files (running from parent directory)" -ForegroundColor $Blue
        Copy-Item -Path ".\meta-competitor-research-mcp\*" -Destination $ServerDir -Recurse -Force
    } else {
        Write-Host "   Downloading from GitHub..." -ForegroundColor $Blue
        
        # Download main files
        $baseUrl = "https://raw.githubusercontent.com/Mohit-Dhawan98/adalyst-mcp/main/meta-competitor-research-mcp"
        Invoke-WebRequest -Uri "$baseUrl/mcp_server.py" -OutFile (Join-Path $ServerDir "mcp_server.py")
        Invoke-WebRequest -Uri "$baseUrl/requirements.txt" -OutFile (Join-Path $ServerDir "requirements.txt")
        Invoke-WebRequest -Uri "$baseUrl/env.template" -OutFile (Join-Path $ServerDir "env.template")
        
        # Create src directory and download service files
        $srcDir = Join-Path $ServerDir "src"
        $servicesDir = Join-Path $srcDir "services"
        New-Item -ItemType Directory -Path $servicesDir -Force | Out-Null
        
        Invoke-WebRequest -Uri "$baseUrl/src/services/scrapecreators_service.py" -OutFile (Join-Path $servicesDir "scrapecreators_service.py")
        Invoke-WebRequest -Uri "$baseUrl/src/services/media_cache_service.py" -OutFile (Join-Path $servicesDir "media_cache_service.py") 
        Invoke-WebRequest -Uri "$baseUrl/src/services/gemini_service.py" -OutFile (Join-Path $servicesDir "gemini_service.py")
        Invoke-WebRequest -Uri "$baseUrl/src/logger.py" -OutFile (Join-Path $srcDir "logger.py")
    }
}

Write-Host "✅ Server files downloaded" -ForegroundColor $Green

# Create virtual environment with UV
Write-Host "🐍 Creating virtual environment..." -ForegroundColor $Yellow
Set-Location $ServerDir
& uv venv --python $PythonCmd
Write-Host "✅ Virtual environment created" -ForegroundColor $Green

# Install dependencies
Write-Host "📚 Installing dependencies..." -ForegroundColor $Yellow
& uv pip install -r requirements.txt
Write-Host "✅ Dependencies installed" -ForegroundColor $Green

# Configure API keys
Write-Host ""
Write-Host "🔑 API Key Configuration" -ForegroundColor $Cyan
Write-Host "========================" -ForegroundColor $Cyan
Write-Host ""

if (-not (Test-Path ".env")) {
    Copy-Item "env.template" ".env"
}

Write-Host "For Meta Competitor Research, you need:" -ForegroundColor $Blue
Write-Host ""
Write-Host "1. ScrapeCreators API Key (Required)" -ForegroundColor $Yellow
Write-Host "   • Sign up at: https://scrapecreators.com/" -ForegroundColor $Cyan
Write-Host "   • Get your API key from the dashboard" -ForegroundColor $Cyan
Write-Host ""
Write-Host "2. Google Gemini API Key (Optional - for video analysis)" -ForegroundColor $Yellow
Write-Host "   • Get yours at: https://aistudio.google.com/app/apikey" -ForegroundColor $Cyan
Write-Host ""

# Get ScrapeCreators API key
do {
    $ScrapeCreatorsKey = Read-Host "Please enter your ScrapeCreators API key"
} while (-not $ScrapeCreatorsKey.Trim())

# Update .env file
$envContent = Get-Content ".env"
$envContent = $envContent -replace "SCRAPECREATORS_API_KEY=.*", "SCRAPECREATORS_API_KEY=$ScrapeCreatorsKey"
Set-Content ".env" $envContent
Write-Host "✅ ScrapeCreators API key configured" -ForegroundColor $Green

# Get Gemini API key (optional)
Write-Host ""
$GeminiKey = Read-Host "Enter your Google Gemini API key (press Enter to skip)"

if ($GeminiKey.Trim()) {
    $envContent = Get-Content ".env"
    $envContent = $envContent -replace "GEMINI_API_KEY=.*", "GEMINI_API_KEY=$GeminiKey"
    Set-Content ".env" $envContent
    Write-Host "✅ Gemini API key configured" -ForegroundColor $Green
} else {
    Write-Host "⚠️  Skipped Gemini API key (video analysis will be disabled)" -ForegroundColor $Yellow
}

# Test the server
Write-Host ""
Write-Host "🧪 Testing server installation..." -ForegroundColor $Yellow

# Create a simple test script
$testScript = @'
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
            
            # Simple timeout check
            time.sleep(3)
            proc.terminate()
            print("✅ Server test passed")
            return True
        else:
            stderr = proc.stderr.read()
            print(f"❌ Server failed to start: {stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Server test error: {e}")
        return False

if __name__ == "__main__":
    sys.exit(0 if test_server() else 1)
'@

Set-Content "test_server.py" $testScript

# Run test
$testResult = & .venv\Scripts\python test_server.py
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Server installation test passed" -ForegroundColor $Green
} else {
    Write-Host "❌ Server installation test failed" -ForegroundColor $Red
    Write-Host "Please check the error messages above." -ForegroundColor $Yellow
    exit 1
}

# Clean up test file
Remove-Item "test_server.py" -Force

# Configure Claude Desktop
Write-Host ""
Write-Host "⚙️  Configuring Claude Desktop..." -ForegroundColor $Yellow

$ClaudeConfigDir = Join-Path $env:APPDATA "Claude"
$ConfigFile = Join-Path $ClaudeConfigDir "claude_desktop_config.json"

New-Item -ItemType Directory -Path $ClaudeConfigDir -Force | Out-Null

# Get the UV Python path and server path
$UvPythonPath = Join-Path $ServerDir ".venv\Scripts\python.exe"
$ServerPath = Join-Path $ServerDir "mcp_server.py"

# Create or update Claude Desktop config
if (Test-Path $ConfigFile) {
    Write-Host "   Updating existing configuration..." -ForegroundColor $Blue
    
    # Backup existing config
    Copy-Item $ConfigFile "$ConfigFile.backup"
    
    # Update JSON config
    try {
        $config = Get-Content $ConfigFile | ConvertFrom-Json
        if (-not $config.mcpServers) {
            $config | Add-Member -Name "mcpServers" -Value @{} -MemberType NoteProperty
        }
        
        $config.mcpServers | Add-Member -Name "adalyst-meta-competitor-research" -Value @{
            command = $UvPythonPath
            args = @($ServerPath)
        } -MemberType NoteProperty -Force
        
        $config | ConvertTo-Json -Depth 10 | Set-Content $ConfigFile
        Write-Host "✅ Configuration updated" -ForegroundColor $Green
    } catch {
        Write-Host "❌ Failed to update config: $($_.Exception.Message)" -ForegroundColor $Red
        exit 1
    }
} else {
    Write-Host "   Creating new configuration..." -ForegroundColor $Blue
    
    $config = @{
        mcpServers = @{
            "adalyst-meta-competitor-research" = @{
                command = $UvPythonPath
                args = @($ServerPath)
            }
        }
    }
    
    $config | ConvertTo-Json -Depth 10 | Set-Content $ConfigFile
    Write-Host "✅ Claude Desktop configured" -ForegroundColor $Green
}

# Final instructions
Write-Host ""
Write-Host "🎉 Installation Complete!" -ForegroundColor $Green
Write-Host "=======================" -ForegroundColor $Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor $Cyan
Write-Host ""
Write-Host "1. Restart Claude Desktop completely" -ForegroundColor $Yellow
Write-Host "   • Close Claude Desktop if running" -ForegroundColor $Cyan
Write-Host "   • Open Claude Desktop again" -ForegroundColor $Cyan
Write-Host ""
Write-Host "2. Wait 10-15 seconds after restart" -ForegroundColor $Yellow  
Write-Host "   • Let Claude load the MCP servers" -ForegroundColor $Cyan
Write-Host ""
Write-Host "3. Test your installation" -ForegroundColor $Yellow
Write-Host "   • Ask Claude: `"What competitor research tools do you have?`"" -ForegroundColor $Cyan
Write-Host "   • Or try: `"Search for Nike's Facebook ads`"" -ForegroundColor $Cyan
Write-Host ""
Write-Host "🚀 Example Queries:" -ForegroundColor $Magenta
Write-Host "   • `"Analyze Nike vs Adidas current ad strategies`"" -ForegroundColor $Cyan
Write-Host "   • `"What messaging themes are fitness brands using?`"" -ForegroundColor $Cyan
Write-Host "   • `"Compare Coca-Cola and Pepsi's recent campaigns`"" -ForegroundColor $Cyan
Write-Host ""
Write-Host "Installation directory: $ServerDir" -ForegroundColor $Green
Write-Host "Claude config file: $ConfigFile" -ForegroundColor $Green
Write-Host ""
Write-Host "Need help? Visit: https://github.com/adalyst/adalyst-mcp" -ForegroundColor $Yellow
Write-Host ""

Read-Host "Press Enter to exit"