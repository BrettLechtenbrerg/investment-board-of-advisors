"""
Investment Board of Advisors - Persona Prompts
"""

from .warren_buffett import WARREN_BUFFETT_PROMPT
from .peter_lynch import PETER_LYNCH_PROMPT
from .ray_dalio import RAY_DALIO_PROMPT
from .john_bogle import JOHN_BOGLE_PROMPT

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
    }
}

__all__ = ['ADVISORS', 'WARREN_BUFFETT_PROMPT', 'PETER_LYNCH_PROMPT',
           'RAY_DALIO_PROMPT', 'JOHN_BOGLE_PROMPT']
