# STEP 5: UI & Final Polish

**Objective:** Build the visible screens using the "Calming" design language defined in the Blueprint.

**Tasks for AI:**
1.  **Reusable Widgets (`lib/presentation/widgets/`):**
    * `ChatBubble`: A distinct bubble for User (Right aligned) and AI (Left aligned). Use soft colors.
    * `TypingIndicator`: A simple animation (3 dots) shown when `ChatState` is loading.
    * `MoodSelector`: A horizontal scrollable list of mood icons/chips.

2.  **Screens (`lib/presentation/screens/`):**
    * **HomeScreen:**
        * Display "How are you feeling?" header.
        * Show `MoodSelector`.
        * "Start Venting" button (leads to ChatScreen).
    * **ChatScreen:**
        * Use a `ListView.builder` connected to `ChatProvider`.
        * Input field at the bottom with a "Send" icon.
        * **Key Detail:** If the user is typing, the UI should feel responsive (no lag).

3.  **Wiring:**
    * Ensure `GoRouter` in `lib/presentation/navigation` points to these actual screens now.

**Design Reminder:**
* Keep it simple.
* Padding: 16.0 standard.
* Radius: 12.0 for card/bubble corners (Soft edges).
* **Animation:** Add mild `Hero` animations or simple transitions if possible.