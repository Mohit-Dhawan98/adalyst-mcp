<div align="center">
  <img src="../assets/TLA Logo.png" alt="Adalyst Logo" width="150"/>
  
  # Meta Competitor Research MCP
  
  **AI-powered Facebook & Instagram competitor analysis for Claude Desktop** 🕵️‍♂️
</div>

Get deep insights into your competitors' advertising strategies, creative approaches, and market positioning directly in Claude Desktop. Analyze their campaigns, extract visual elements, and discover what's working in your industry.

## ✨ What You Can Do

### 🎯 Competitor Intelligence
- **Search any brand** on Facebook/Instagram and get their current ads
- **Batch analysis** - compare multiple competitors at once
- **Campaign insights** - understand their messaging and targeting strategies
- **Market positioning** analysis across your industry

### 🎨 Creative Analysis  
- **AI-powered image analysis** - extract colors, text, people, brand elements
- **Video strategy insights** - analyze pacing, hooks, and visual storytelling
- **Design pattern recognition** - identify successful creative approaches
- **A/B testing insights** - see multiple variants and approaches

### 📊 Strategic Intelligence
- **Messaging themes** - understand competitor value propositions
- **Seasonal campaigns** - track how competitors adapt to holidays/events  
- **Budget indicators** - gauge competitor ad spend and priority campaigns
- **Market share insights** - see who's most active in your space

---

## 🚀 Quick Install (2 minutes)

### 🍎 macOS / 🐧 Linux
```bash
# 1. Download this repo
git clone https://github.com/Mohit-Dhawan98/adalyst-mcp.git
cd adalyst-mcp/meta-competitor-research-mcp

# 2. Run the installer
./install.sh

# 3. Restart Claude Desktop
# 4. Ask Claude about your competitors! 🎉
```

### 🪟 Windows  
```powershell
# 1. Download this repo
git clone https://github.com/Mohit-Dhawan98/adalyst-mcp.git
cd adalyst-mcp/meta-competitor-research-mcp

# 2. Run the installer
./install.ps1

# 3. Restart Claude Desktop
# 4. Ask Claude about your competitors! 🎉
```

The installer automatically handles:
- ✅ Python 3.11 installation
- ✅ UV package manager setup  
- ✅ All dependencies
- ✅ API key configuration
- ✅ Claude Desktop integration
- ✅ Testing and validation

---

## 🔑 API Keys Needed

### Required: ScrapeCreators API
- **What it does**: Access Facebook Ad Library data
- **Cost**: Pay-per-use (very affordable for research)
- **Get yours**: [scrapecreators.com](https://scrapecreators.com/)
- **Why we use it**: Official Facebook API is restricted, ScrapeCreators provides reliable access

### Optional: Google Gemini API  
- **What it does**: AI-powered video analysis
- **Cost**: Free tier available, then pay-per-use
- **Get yours**: [Google AI Studio](https://aistudio.google.com/app/apikey)
- **Why optional**: Only needed for video ad analysis (images work without it)

*The installer will guide you through getting these keys - it's easier than it sounds!*

---

## 🎯 Professional Research Prompt

For the most comprehensive competitive analysis, use this expert-level prompt:

**[📋 Copy Professional Research Prompt](./sample_prompt.md)**

This advanced prompt includes:
- ✅ **Adaptive decision tree** for different research scenarios
- ✅ **Systematic methodology** for finding competitor ads  
- ✅ **Quality standards** for thorough analysis
- ✅ **Professional output formats** for strategic insights

Simply copy the prompt, fill in your brand/market details, and get institutional-quality competitive intelligence.

---

## 💬 Quick Example Queries

For simple analyses, you can also ask Claude things like:

### Single Competitor Analysis
```
"Analyze Nike's current Facebook ad strategy"
```

```
"What messaging themes is Apple using in their ads right now?"
```

```
"Show me Spotify's latest video ad creative and analyze the storytelling approach"
```

### Competitive Intelligence
```
"Compare the current advertising strategies of Nike vs Adidas vs Under Armour"
```

```
"What are the top 3 messaging themes fitness brands are using this month?"
```

```
"Analyze how streaming services (Netflix, Disney+, Hulu) are positioning themselves differently"
```

### Market Research
```
"What creative approaches are working for SaaS companies in their Facebook ads?"
```

```
"Show me holiday campaign strategies across major retail brands"
```

### Creative Analysis
```
"Analyze the visual elements and color schemes in Tesla's current ads"
```

```
"What hooks and pacing strategies are most successful in fitness app video ads?"
```

---

## 🛠️ Available Tools

The MCP server provides these tools to Claude:

| Tool | Description |
|------|-------------|
| `get_meta_platform_id` | Search for brands and get their Facebook Platform IDs |
| `get_meta_ads` | Retrieve current ads for any brand |
| `analyze_ad_image` | AI analysis of image ads (colors, text, people, branding) |
| `analyze_ad_video` | AI analysis of video ads (storytelling, pacing, hooks) |
| `analyze_ad_videos_batch` | Batch video analysis for efficiency |
| `get_cache_stats` | Check cached data and storage usage |
| `search_cached_media` | Search previously analyzed ads |
| `cleanup_media_cache` | Clean up old cached files |

---

## 🎬 How It Works

1. **Search**: Tell Claude to search for a competitor (e.g., "Nike")
2. **Retrieve**: Claude finds their Facebook Platform ID and gets their current ads  
3. **Analyze**: AI analyzes the creative elements, messaging, and strategy
4. **Insights**: Get actionable intelligence about their approach
5. **Compare**: Analyze multiple competitors to find patterns and opportunities

All data is cached locally for fast repeated analysis and to minimize API costs.

---

## 🔧 Manual Installation (Advanced)

If you prefer manual setup:

### 1. Prerequisites
```bash
# Python 3.11 (required)
python3.11 --version

# UV package manager (recommended) 
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Setup
```bash
# Clone and enter directory
git clone https://github.com/Mohit-Dhawan98/adalyst-mcp.git  
cd adalyst-mcp/meta-competitor-research-mcp

# Create virtual environment
uv venv --python python3.11

# Install dependencies  
uv pip install -r requirements.txt

# Configure API keys
cp env.template .env
# Edit .env and add your API keys
```

### 3. Claude Desktop Config
Add this to your `claude_desktop_config.json`:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`  
**Linux**: `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "meta-competitor-research": {
      "command": "/path/to/your/adalyst-mcp/meta-competitor-research-mcp/.venv/bin/python",
      "args": ["/path/to/your/adalyst-mcp/meta-competitor-research-mcp/mcp_server.py"]
    }
  }
}
```

### 4. Test & Restart
```bash
# Test the server
.venv/bin/python mcp_server.py

# Restart Claude Desktop completely (Cmd+Q on Mac)
```

---

## 🐛 Troubleshooting

### Claude doesn't see the tools
- **Restart Claude Desktop completely** (Cmd+Q on Mac, not just close)
- Wait 10-15 seconds after restart for MCP servers to load
- Check that the paths in `claude_desktop_config.json` are correct

### API errors
- Verify your API keys in the `.env` file
- Check that ScrapeCreators API key is active and has credits
- For video analysis issues, check Gemini API key

### Python/dependency issues
- Make sure Python 3.11 is installed: `python3.11 --version`
- Try reinstalling dependencies: `uv pip install -r requirements.txt --force-reinstall`

### Installation issues
- Make sure you have internet connection
- On macOS, install Homebrew if prompted
- On Linux, make sure you have sudo access for package installation

### Still having issues?
1. Check the full error message
2. [Open an issue](https://github.com/Mohit-Dhawan98/adalyst-mcp/issues) with:
   - Your operating system
   - Full error message
   - Steps you've tried

---

## 📊 Usage Costs

### ScrapeCreators API
- ~$0.01-0.05 per brand search
- ~$0.02-0.10 per ad retrieval (50 ads)
- Very affordable for competitive research

### Google Gemini API (Optional)
- Free tier: 15 requests/minute
- Paid: ~$0.002 per video analysis
- Only needed for video ads

**Example**: Analyzing 5 competitors with 10 ads each = ~$1-3 total

---

## 🔒 Privacy & Data

- **No data collection**: Everything runs locally on your machine
- **Cached locally**: Downloaded ads are cached on your computer for efficiency  
- **Your API keys**: Stored only in your local `.env` file
- **Facebook public data**: Only accesses publicly available ads from Facebook Ad Library

---

## 📄 License

MIT License - See [LICENSE](../LICENSE) for details.

---

## 🆘 Support

- 🐛 **Bug reports**: [GitHub Issues](https://github.com/Mohit-Dhawan98/adalyst-mcp/issues)
- 💬 **Questions**: [GitHub Discussions](https://github.com/Mohit-Dhawan98/adalyst-mcp/discussions)  
- 📧 **Email**: support@adalyst.ai

---

<div align="center">

**Ready to analyze your competition?**

[🚀 Install Now](#-quick-install-2-minutes) | [⬅️ Back to Main](../README.md) | [💬 Get Support](#-support)

</div>