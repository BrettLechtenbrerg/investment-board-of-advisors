#!/usr/bin/env python3
"""
Investment Board of Advisors
Consult with AI versions of legendary investors

Usage:
    python main.py                           # Interactive mode
    python main.py --advisor warren_buffett  # Single advisor
    python main.py --board-meeting           # All advisors weigh in
    python main.py --question "Your question" # Direct question
"""

import os
import sys
import argparse
from typing import Optional
from dotenv import load_dotenv
from anthropic import Anthropic

from personas import ADVISORS

# Load environment variables
load_dotenv()

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    GOLD = '\033[33m'
    BOLD = '\033[1m'
    END = '\033[0m'

def get_client() -> Anthropic:
    """Get Anthropic client with API key from environment"""
    api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key:
        print(f"{Colors.RED}Error: ANTHROPIC_API_KEY not found in environment{Colors.END}")
        print("Please set it in your .env file or export it")
        sys.exit(1)
    return Anthropic(api_key=api_key)

def consult_advisor(
    client: Anthropic,
    advisor_key: str,
    question: str,
    context: Optional[str] = None
) -> str:
    """Get advice from a single advisor"""

    advisor = ADVISORS.get(advisor_key)
    if not advisor:
        return f"Unknown advisor: {advisor_key}"

    system_prompt = advisor["prompt"]

    user_message = question
    if context:
        user_message = f"CONTEXT: {context}\n\nQUESTION: {question}"

    response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=2048,
        system=system_prompt,
        messages=[
            {"role": "user", "content": user_message}
        ]
    )

    return response.content[0].text

def run_board_meeting(
    client: Anthropic,
    question: str,
    context: Optional[str] = None,
    advisors_to_consult: Optional[list] = None
) -> dict:
    """Get advice from multiple advisors (board meeting style)"""

    if advisors_to_consult is None:
        advisors_to_consult = list(ADVISORS.keys())

    results = {}

    for advisor_key in advisors_to_consult:
        advisor = ADVISORS[advisor_key]
        print(f"\n{Colors.CYAN}Consulting {advisor['emoji']} {advisor['name']}...{Colors.END}")

        advice = consult_advisor(client, advisor_key, question, context)
        results[advisor_key] = {
            "name": advisor["name"],
            "title": advisor["title"],
            "emoji": advisor["emoji"],
            "advice": advice
        }

    return results

def synthesize_advice(client: Anthropic, question: str, board_results: dict) -> str:
    """Synthesize all advisor opinions into actionable recommendations"""

    synthesis_prompt = """You are a skilled investment analyst tasked with synthesizing advice
from a board of legendary investors. Your job is to:

1. Identify the KEY THEMES that multiple advisors agree on
2. Note any CONTRASTING PERSPECTIVES that might both be valid (different investment styles)
3. Create a SYNTHESIZED RECOMMENDATION with specific considerations
4. Highlight any WARNINGS or risk factors the advisors mentioned

IMPORTANT: Always include a disclaimer that this is for educational purposes only and not financial advice.

Be concise and actionable. Focus on the key investment principles and considerations."""

    advisors_text = ""
    for key, result in board_results.items():
        advisors_text += f"\n\n=== {result['emoji']} {result['name']} ({result['title']}) ===\n"
        advisors_text += result['advice']

    user_message = f"""ORIGINAL QUESTION: {question}

ADVISOR RESPONSES:{advisors_text}

Please synthesize these investment perspectives into actionable recommendations."""

    response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=2048,
        system=synthesis_prompt,
        messages=[
            {"role": "user", "content": user_message}
        ]
    )

    return response.content[0].text

def print_advisor_list():
    """Print available advisors"""
    print(f"\n{Colors.BOLD}📋 Available Investment Advisors:{Colors.END}\n")
    for key, advisor in ADVISORS.items():
        print(f"  {advisor['emoji']} {Colors.GREEN}{key:<18}{Colors.END} - {advisor['name']} ({advisor['title']})")
    print()

def print_board_results(results: dict, synthesis: Optional[str] = None):
    """Pretty print board meeting results"""
    print(f"\n{Colors.BOLD}{'='*60}{Colors.END}")
    print(f"{Colors.GOLD}💰 INVESTMENT BOARD OF ADVISORS RESPONSES{Colors.END}")
    print(f"{Colors.BOLD}{'='*60}{Colors.END}")

    for key, result in results.items():
        print(f"\n{Colors.HEADER}{'='*60}{Colors.END}")
        print(f"{result['emoji']} {Colors.BOLD}{result['name']}{Colors.END}")
        print(f"{Colors.CYAN}{result['title']}{Colors.END}")
        print(f"{Colors.HEADER}{'='*60}{Colors.END}")
        print(result['advice'])

    if synthesis:
        print(f"\n{Colors.YELLOW}{'='*60}{Colors.END}")
        print(f"🎯 {Colors.BOLD}SYNTHESIZED INVESTMENT ANALYSIS{Colors.END}")
        print(f"{Colors.YELLOW}{'='*60}{Colors.END}")
        print(synthesis)

def interactive_mode(client: Anthropic):
    """Run in interactive mode with menu"""

    print(f"\n{Colors.BOLD}💰  INVESTMENT BOARD OF ADVISORS  💰{Colors.END}")
    print(f"{Colors.GOLD}Get wisdom from legendary investors{Colors.END}\n")

    while True:
        print(f"\n{Colors.BOLD}What would you like to do?{Colors.END}")
        print("  1. Consult a single advisor")
        print("  2. Call a board meeting (all advisors)")
        print("  3. Quick board meeting (select advisors)")
        print("  4. List available advisors")
        print("  5. Exit")

        choice = input(f"\n{Colors.GREEN}Enter choice (1-5): {Colors.END}").strip()

        if choice == "1":
            print_advisor_list()
            advisor_key = input(f"{Colors.GREEN}Enter advisor key: {Colors.END}").strip().lower()

            if advisor_key not in ADVISORS:
                print(f"{Colors.RED}Unknown advisor. Use 'list' to see options.{Colors.END}")
                continue

            question = input(f"\n{Colors.GREEN}What's your investment question?\n> {Colors.END}").strip()
            if not question:
                continue

            context = input(f"{Colors.GREEN}Any context? (portfolio size, timeline, etc. - press Enter to skip)\n> {Colors.END}").strip() or None

            advisor = ADVISORS[advisor_key]
            print(f"\n{Colors.CYAN}Consulting {advisor['emoji']} {advisor['name']}...{Colors.END}\n")

            advice = consult_advisor(client, advisor_key, question, context)

            print(f"\n{Colors.HEADER}{'='*60}{Colors.END}")
            print(f"{advisor['emoji']} {Colors.BOLD}{advisor['name']}{Colors.END}")
            print(f"{Colors.HEADER}{'='*60}{Colors.END}")
            print(advice)

        elif choice == "2":
            question = input(f"\n{Colors.GREEN}What's your investment question for the board?\n> {Colors.END}").strip()
            if not question:
                continue

            context = input(f"{Colors.GREEN}Any context? (press Enter to skip)\n> {Colors.END}").strip() or None

            results = run_board_meeting(client, question, context)

            do_synthesis = input(f"\n{Colors.GREEN}Synthesize into investment analysis? (y/n): {Colors.END}").strip().lower()
            synthesis = None
            if do_synthesis == 'y':
                print(f"\n{Colors.CYAN}Synthesizing investment perspectives...{Colors.END}")
                synthesis = synthesize_advice(client, question, results)

            print_board_results(results, synthesis)

        elif choice == "3":
            print_advisor_list()
            selected = input(f"{Colors.GREEN}Enter advisor keys (comma-separated): {Colors.END}").strip()
            advisors_list = [a.strip().lower() for a in selected.split(",")]

            # Validate
            valid_advisors = [a for a in advisors_list if a in ADVISORS]
            if not valid_advisors:
                print(f"{Colors.RED}No valid advisors selected.{Colors.END}")
                continue

            question = input(f"\n{Colors.GREEN}What's your investment question?\n> {Colors.END}").strip()
            if not question:
                continue

            context = input(f"{Colors.GREEN}Any context? (press Enter to skip)\n> {Colors.END}").strip() or None

            results = run_board_meeting(client, question, context, valid_advisors)

            do_synthesis = input(f"\n{Colors.GREEN}Synthesize into investment analysis? (y/n): {Colors.END}").strip().lower()
            synthesis = None
            if do_synthesis == 'y':
                print(f"\n{Colors.CYAN}Synthesizing investment perspectives...{Colors.END}")
                synthesis = synthesize_advice(client, question, results)

            print_board_results(results, synthesis)

        elif choice == "4":
            print_advisor_list()

        elif choice == "5":
            print(f"\n{Colors.CYAN}Thanks for consulting the Investment Board! May your returns be ever in your favor! 📈{Colors.END}\n")
            break
        else:
            print(f"{Colors.RED}Invalid choice. Please enter 1-5.{Colors.END}")

def main():
    parser = argparse.ArgumentParser(
        description="Consult your Investment Board of Advisors",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main.py                                    # Interactive mode
  python main.py --list                             # List advisors
  python main.py --advisor warren_buffett -q "Should I buy index funds?"
  python main.py --board-meeting -q "Is this stock overvalued?" --synthesize
  python main.py --advisors warren_buffett,peter_lynch -q "How do I find great companies?"
        """
    )

    parser.add_argument("--list", action="store_true", help="List available advisors")
    parser.add_argument("--advisor", "-a", type=str, help="Single advisor to consult")
    parser.add_argument("--advisors", type=str, help="Comma-separated list of advisors")
    parser.add_argument("--board-meeting", "-b", action="store_true", help="Consult all advisors")
    parser.add_argument("--question", "-q", type=str, help="Your investment question")
    parser.add_argument("--context", "-c", type=str, help="Additional context (portfolio size, timeline, etc.)")
    parser.add_argument("--synthesize", "-s", action="store_true", help="Synthesize advice into investment analysis")

    args = parser.parse_args()

    # List advisors
    if args.list:
        print_advisor_list()
        return

    # Get client
    client = get_client()

    # Single advisor mode
    if args.advisor and args.question:
        if args.advisor not in ADVISORS:
            print(f"{Colors.RED}Unknown advisor: {args.advisor}{Colors.END}")
            print_advisor_list()
            return

        advisor = ADVISORS[args.advisor]
        print(f"\n{Colors.CYAN}Consulting {advisor['emoji']} {advisor['name']}...{Colors.END}\n")

        advice = consult_advisor(client, args.advisor, args.question, args.context)

        print(f"\n{Colors.HEADER}{'='*60}{Colors.END}")
        print(f"{advisor['emoji']} {Colors.BOLD}{advisor['name']}{Colors.END}")
        print(f"{Colors.HEADER}{'='*60}{Colors.END}")
        print(advice)
        return

    # Board meeting mode (all advisors)
    if args.board_meeting and args.question:
        results = run_board_meeting(client, args.question, args.context)

        synthesis = None
        if args.synthesize:
            print(f"\n{Colors.CYAN}Synthesizing investment perspectives...{Colors.END}")
            synthesis = synthesize_advice(client, args.question, results)

        print_board_results(results, synthesis)
        return

    # Selected advisors mode
    if args.advisors and args.question:
        advisors_list = [a.strip().lower() for a in args.advisors.split(",")]
        valid_advisors = [a for a in advisors_list if a in ADVISORS]

        if not valid_advisors:
            print(f"{Colors.RED}No valid advisors selected.{Colors.END}")
            print_advisor_list()
            return

        results = run_board_meeting(client, args.question, args.context, valid_advisors)

        synthesis = None
        if args.synthesize:
            print(f"\n{Colors.CYAN}Synthesizing investment perspectives...{Colors.END}")
            synthesis = synthesize_advice(client, args.question, results)

        print_board_results(results, synthesis)
        return

    # Default to interactive mode
    interactive_mode(client)

if __name__ == "__main__":
    main()
