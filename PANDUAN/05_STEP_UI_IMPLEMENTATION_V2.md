# STEP 5: UI & Final Polish (V2 - Aurora & Glassmorphism)

**Objective:** Build the visible screens using the "Living UI" philosophy. NO FLAT GREY BACKGROUNDS.

**Tasks for AI:**
1.  **Visual Components (`lib/presentation/widgets/fx/`):**
    * `AuroraBackground`: A widget that sits behind everything. Uses `AnimatedContainer` or `MeshGradient` to slowly shift colors based on `ThemeState.activeGradientColor`.
    * `GlassContainer`: A wrapper widget using `BackdropFilter` (Blur) + `Container` (White with low opacity) + `Border` (White with very low opacity).

2.  **Core Widgets (`lib/presentation/widgets/`):**
    * `LivingTypingIndicator`: Not just text. A central Orb (Circle) that scales up and down (`flutter_animate`) with a "Glow" shadow.
    * `ChatBubble`: Wrapped in `GlassContainer`. User = Slight tint. AI = Clear Glass.

3.  **Screens (`lib/presentation/screens/`):**
    * **HomeScreen:**
        * Background: Aurora (Calm/Neutral).
        * Center: "How are you feeling?" floating on Glass Card.
        * Mood Selector: Chips that trigger color changes immediately on tap.
    * **ChatScreen:**
        * Background: Inherits the Aurora from Home.
        * AppBar: Transparent (Glass).
        * Chat List: Smooth scroll.
        * Input Area: Floating Glass Bar at the bottom.

**Design Rules:**
* **Font:** Google Fonts Poppins.
* **Motion:** All color changes must have `duration: 500ms` or more (Slow & Calming).
* **Contrast:** Ensure text is readable on top of Glass/Gradient (Use White text with shadow for Dark Aurora, Dark text for Light Aurora).