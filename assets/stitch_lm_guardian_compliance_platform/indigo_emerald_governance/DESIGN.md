---
name: Indigo Emerald Governance
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#44474c'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#75777d'
  outline-variant: '#c5c6cd'
  surface-tint: '#525f74'
  primary: '#182537'
  on-primary: '#ffffff'
  primary-container: '#2e3b4e'
  on-primary-container: '#98a5bc'
  inverse-primary: '#bac7df'
  secondary: '#516072'
  on-secondary: '#ffffff'
  secondary-container: '#d2e1f7'
  on-secondary-container: '#556477'
  tertiary: '#002b1f'
  on-tertiary: '#ffffff'
  tertiary-container: '#004332'
  on-tertiary-container: '#73b098'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3fc'
  primary-fixed-dim: '#bac7df'
  on-primary-fixed: '#0e1c2e'
  on-primary-fixed-variant: '#3a475b'
  secondary-fixed: '#d4e4fa'
  secondary-fixed-dim: '#b9c8de'
  on-secondary-fixed: '#0d1c2d'
  on-secondary-fixed-variant: '#39485a'
  tertiary-fixed: '#b0f0d6'
  tertiary-fixed-dim: '#95d3ba'
  on-tertiary-fixed: '#002117'
  on-tertiary-fixed-variant: '#0b513d'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
  indigo-slate: '#2E3B4E'
  forest-emerald: '#064E3B'
  silver-gray: '#94A3B8'
  soft-mint: '#ECFDF5'
  compliance-green: '#059669'
  compliance-amber: '#D97706'
  compliance-red: '#DC2626'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm-mobile:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-page: 1.5rem
  gutter-grid: 1rem
  stack-sm: 0.5rem
  stack-md: 1rem
  stack-lg: 2rem
  touch-target: 2.75rem
---

## Brand & Style

The design system is tailored for high-trust regulatory environments, balancing institutional authority with modern technological precision. The brand persona is defined by **Integrity, Sophistication, and Stability**. It shifts away from generic utility toward a refined, executive aesthetic that commands respect while remaining highly functional for field operations.

The visual style is **Corporate / Modern** with a lean toward **Minimalism**. It utilizes a "Surface-on-Surface" approach to create a clean, organized information architecture. By pairing deep, saturated primary tones with muted secondary neutrals, the system evokes the feeling of a premium, secure government platform.

Key attributes:
- **High-Trust:** A palette and layout that feels established and dependable.
- **Modern Governance:** Technical precision delivered through clean lines and generous white space.
- **Professionalism:** High-contrast typography and sophisticated color pairings that prioritize readability and clarity.

## Colors

This design system replaces standard digital blues with a sophisticated **Indigo Slate (#2E3B4E)** as the primary brand color. This deep, desaturated blue provides a neutral yet authoritative foundation. **Forest Emerald (#064E3B)** is introduced as a tertiary accent to signify growth and environmental or regulatory health.

**Secondary elements** utilize **Silver Gray (#94A3B8)** for subtle borders and secondary actions, while **Soft Mint (#ECFDF5)** serves as a gentle background tint for highlighting success states or containers.

**Functional Colors:**
- **Green (Success/Compliant):** Refined to a deep Emerald tone to match the palette.
- **Amber (Warning/Review):** A muted, earthy gold that maintains visibility without appearing garish.
- **Red (Error/Violation):** A sophisticated crimson that communicates urgency while remaining professional.

The background uses a crisp **Slate White (#F8FAFC)** to ensure the deep primary and secondary colors remain the focal point.

## Typography

This design system maintains **Inter** as its sole typeface to leverage its exceptional clarity in data-dense environments. The typographic hierarchy is optimized for technical reports and mobile field-use, where legibility is paramount.

High-level headings use the deep **Indigo Slate** color to anchor the page, while body text utilizes a slightly lighter charcoal to reduce visual fatigue. **Labels** are consistently presented in Uppercase with a slight letter-spacing of 0.05em to differentiate metadata from user-entered content. Numerical data points should prioritize the SemiBold (600) weight to ensure key metrics are immediately scannable.

## Layout & Spacing

The system employs a **Fluid Grid** model with a focus on logical containment. For desktop, a 12-column grid is used; for mobile, a single-column stack with 24px (1.5rem) side margins ensures content does not feel crowded at the edges.

A strictly enforced 8px spatial rhythm governs all padding and margins. Vertical stacks utilize `stack-lg` (32px) to separate major sections and `stack-sm` (8px) for internal element grouping. All interactive elements must adhere to a minimum `touch-target` of 44px to maintain accessibility for field agents using devices in various orientations.

## Elevation & Depth

Visual hierarchy is conveyed through **Tonal Layers** and **Low-Contrast Outlines**. Instead of heavy shadows, the system uses subtle background shifts to indicate depth.

- **Surface Level 0:** The base application background (#F8FAFC).
- **Surface Level 1:** White content cards with a 1px border in a very light Slate tone (#E2E8F0).
- **Surface Level 2:** Floating elements or modals use a soft, ambient shadow (0px 10px 25px rgba(46, 59, 78, 0.08)) to appear gently lifted above the workspace.

This approach creates a "flat-plus" look that feels modern and lightweight, avoiding the clutter of excessive skeuomorphism while maintaining clear functional separation.

## Shapes

The design system adheres to a **Rounded (Level 2)** shape language, specifically the `ROUND_EIGHT` standard. This 8px (0.5rem) base radius provides a friendly yet professional finish to rigid data structures.

- **Standard Elements:** Buttons, input fields, and tags use the 8px radius.
- **Large Containers:** Content cards and dashboard modules use a 16px (1rem) radius.
- **Indicators:** Status pills and small avatars use a "Full" pill shape for maximum contrast against rectangular data fields.

## Components

### Buttons
- **Primary:** Solid Indigo Slate (#2E3B4E) with White text. Bold and authoritative.
- **Secondary:** Outline style using Silver Gray (#94A3B8) with a 1.5px border, used for secondary actions like "Export" or "Cancel".
- **Tertiary:** Solid Forest Emerald (#064E3B) with White text, reserved for "Finalize" or "Approve" actions.

### Input Fields
- Form inputs feature an 8px radius, a White background, and a Silver Gray border. On focus, the border transitions to Indigo Slate with a subtle 2px outer glow.

### Cards & Containers
- Cards are the primary organizational unit. They use a White surface, 8px radius, and a 1px Slate border. For compliance results, a 4px left-accent border in the respective status color (Green/Amber/Red) should be applied.

### Status Chips
- High-trust status pills use a 10% opacity background of the status color with 100% opacity bold text. For example, a "Compliant" chip uses a Soft Mint background with Forest Emerald text.

### Progress & Scanning
- Scanning overlays should use a semi-transparent Indigo Slate mask with a high-contrast Forest Emerald "target" frame to guide the user's focus during AI analysis.