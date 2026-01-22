"""
Investment Board of Advisors - Persona Prompts
"""

from .warren_buffett import WARREN_BUFFETT_PROMPT
from .peter_lynch import PETER_LYNCH_PROMPT
from .ray_dalio import RAY_DALIO_PROMPT
from .john_bogle import JOHN_BOGLE_PROMPT
from .benjamin_graham import BENJAMIN_GRAHAM_PROMPT
from .george_soros import GEORGE_SOROS_PROMPT
from .howard_marks import HOWARD_MARKS_PROMPT
from .carl_icahn import CARL_ICAHN_PROMPT
from .cathie_wood import CATHIE_WOOD_PROMPT

ADVISORS = {
    "warren_buffett": {
        "name": "Warren Buffett",
        "title": "Value Investing & Business Analysis",
        "prompt": WARREN_BUFFETT_PROMPT,
        "emoji": "📈"
    },
    "peter_lynch": {
        "name": "Peter Lynch",
        "title": "Growth Investing & Research",
        "prompt": PETER_LYNCH_PROMPT,
        "emoji": "🧪"
    },
    "ray_dalio": {
        "name": "Ray Dalio",
        "title": "Macro Economics & Principles",
        "prompt": RAY_DALIO_PROMPT,
        "emoji": "🌊"
    },
    "john_bogle": {
        "name": "John Bogle",
        "title": "Index Investing & Low-Cost Strategy",
        "prompt": JOHN_BOGLE_PROMPT,
        "emoji": "📊"
    },
    "benjamin_graham": {
        "name": "Benjamin Graham",
        "title": "Father of Value Investing & Margin of Safety",
        "prompt": BENJAMIN_GRAHAM_PROMPT,
        "emoji": "📚"
    },
    "george_soros": {
        "name": "George Soros",
        "title": "Macro Trading & Reflexivity",
        "prompt": GEORGE_SOROS_PROMPT,
        "emoji": "🌍"
    },
    "howard_marks": {
        "name": "Howard Marks",
        "title": "Risk Assessment & Market Cycles",
        "prompt": HOWARD_MARKS_PROMPT,
        "emoji": "📝"
    },
    "carl_icahn": {
        "name": "Carl Icahn",
        "title": "Activist Investing & Corporate Governance",
        "prompt": CARL_ICAHN_PROMPT,
        "emoji": "⚔️"
    },
    "cathie_wood": {
        "name": "Cathie Wood",
        "title": "Disruptive Innovation & Growth",
        "prompt": CATHIE_WOOD_PROMPT,
        "emoji": "🚀"
    }
}

__all__ = ['ADVISORS', 'WARREN_BUFFETT_PROMPT', 'PETER_LYNCH_PROMPT',
           'RAY_DALIO_PROMPT', 'JOHN_BOGLE_PROMPT', 'BENJAMIN_GRAHAM_PROMPT',
           'GEORGE_SOROS_PROMPT', 'HOWARD_MARKS_PROMPT', 'CARL_ICAHN_PROMPT',
           'CATHIE_WOOD_PROMPT']
