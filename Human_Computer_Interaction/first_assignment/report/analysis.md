### Aesthetic & Minimalism  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Efficient & Aesthetic | Aesthetic & Minimal Design |
| The design should be both visually appealing and functional, ensuring efficiency in user interaction. | The interface should be simple, free from unnecessary elements, and visually focused on essential tasks. |


![homePageMST](../assets/homePage.png)
![homePageMSTMobile](../assets/homePageMSTMobile.png)

**Good:**  
- The design is clean looking, with a well thought out color pallete.
- The theme, typography and spacing is consistent. 
- Effective use of white space enhansing readability.
- There is no clutter, and all the UI elements focus on essential tasks that a user might do.
- The design is consistent across both mobile and desktop.

Overall, the design is clean, consistent, and free from clutter, aligning well with Aesthetic & Minimalism. Removing the "We Are Here" callout on mobile would further enhance simplicity.

---

### User Control & Freedom  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| User in Control | User Control & Freedom |
| Users should feel in control of their actions, with the ability to initiate and correct them easily. | Users should always have options to undo, redo, or exit actions without being stuck. |

![homePageMST](../assets/homePage.png)
![hamburgerMenu](../assets/hamburgerMenu.png)

#### Things To Look Out For:
- Availability of undo, redo, and exit options  
- Easy navigation and ability to return to previous states  
- No forced actions (e.g., auto-submitting forms without confirmation)  
- Clear and accessible settings/preferences  

**Good:**  
- Easy navigation with the tab based layout on desktop, and hamburger menu on smaller screens.
- The settings and preferences are clearly accessible via the profile page.
- There are no forced actions

Overall, the platform aligns well with User Control & Freedom, offering easy navigation, accessible settings, and no forced actions, with no notable improvements needed.

---

### Easy Recovery & Error Handling  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Easy to Reverse Actions | Help Users Recognize, Diagnose, & Recover from Errors |
| Users should have a way to undo mistakes without major consequences. | When errors occur, users should receive clear feedback and instructions on how to fix them. |


![savedSucecssfully](../assets/savedSucecssfully.png)
![404Page](../assets/404PageTypeDeal.png)
**Good:**  
- Clear error messages with actionable solutions.
- Visiting an invalid URL, provides a clear error message, that allows the user to go back with the `Take me to a safe place` button.

**Bad:**  
- There is no auto-saving feature to prevent data loss.
- The inavailability of undo or redo actions.

Overall, the platform aligns well with Easy Recovery & Error Handling, providing clear error messages and recovery options. However, adding auto-save and replacing "Dismiss" with an "Undo" option after saving would improve usability.

---

### Error Prevention  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Prevent Errors Like a Pro | Error Prevention |
| Design should minimize the chance of user mistakes by guiding them correctly. | Systems should be built to prevent errors before they happen through validation and constraints. |


![ErrorPrevention](../assets/ErrorPrevention.png)
![InvalidNickName](../assets/invalidNickname.png)
![usernametaken](../assets/usernametaken.png)
![empty](../assets/emptyFieldPrevention.png)
#### Things To Look Out For:
- Confirmation dialogs before critical actions (e.g., deleting accounts)  
- Input validation to prevent incorrect data submission  
- Limited destructive actions (e.g., irreversible deletions)  
- Warnings before proceeding with risky actions  

**Good:**  
- Input validation in place to prevent incorrect data submissions.
- There aren't any irreversible destructive actions available, such as deleting your own account.

**Bad:**
- No Confirmation dialog when logging out.

Overall, the platform aligns well with Error Prevention, with input validation and no irreversible actions. However, adding a confirmation dialog for logging out would prevent accidental clicks.

---

### Reduce Cognitive Load  
| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Minimal Memory Load | Recognition Over Recall |
| Users should not have to remember complex details; the UI should assist them. | The system should make options visible and easy to recognize instead of requiring users to recall information. |

![homePageMST](../assets/homePage.png)
![notWorkingSearch](../assets/notWorkingSearch.png)
![empty](../assets/emptyFieldPrevention.png)
#### Things To Look Out For:
- Icons and labels that clearly indicate their function  
- Predictable navigation patterns  
- Auto-fill and suggestion features  
- No need to remember complex commands or sequences  

**Good:**  
- There are well recognized icons and labels to clearly indicate their respective functions.
- There are clear lables in input fields.
- Navigation patterns are predictable.

**Bad:**  
- Disregarding the fact that the search functionality doesn't work, it also doesn't provide auto-fill and suggestion.

Overall, the platform follows the principle of reducing cognitive load well, with clear icons, labels, and predictable navigation. A key improvement would be adding auto-fill and suggestion features in search to enhance usability.

---

### Speed & Efficiency  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Shortcuts for Pros | Flexibility & Efficiency |
| Experienced users should have faster ways to complete tasks, like shortcuts. | The system should cater to both beginners and experts by allowing customization and efficiency tools. |


![loadTimes](../assets/loadTimes.png)
![notWorkingSearch](../assets/notWorkingSearch.png)

**Good:**  
- No unnecessary delays, with excessive animations.
- The website loads quick, loading in an average of < 3 seconds

**Bad:**  
- There is no website built keyboard shortcut in place. Furthermore, even shortcuts that should've been global across all websites (browser's undo/redo) is inconsistent.
- Although search bar does exist, it doesn't work.
- There aren't any customizable settings particularly in place to enhance workflow

Overall, the platform performs well in terms of Speed & Efficiency with quick load times and minimal delays. However, improvements can be made by adding keyboard shortcuts, ensuring search functionality works, and providing customizable settings to enhance workflow.

---

### Clear Feedback & System Status  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Good Feedback, Fast | Visibility of System Status |
| The system should provide immediate and clear feedback on user actions. | Users should always know what is happening through real-time status indicators. |

![savedSuccessfully](../assets/savedSucecssfully.png)
![buttonPressedEffect](../assets/buttonPressedEffect.png)
![noLoadingIndicators](../assets/noLoadingIndicators.png)

**Good:**  
- Existence of system status indicators such as "saved successfully"
- Notification message for completed or failed actions
- Instant visual feedback on user actions with button press effects

**Bad:**  
- Lack of loading indicators entirely.

Overall, the platform aligns well with Clear Feedback & System Status, providing status indicators and instant feedback on user actions. However, adding loading indicators would improve the user experience, especially in poor network conditions.

---

### Consistency  

| Bob Shneiderman | Jakob Nielsen |
|---|---|
| Consistency is Key | Consistency & Standards |
| Elements should behave predictably and follow a uniform design. | The system should align with established design patterns and not force users to learn new behaviors. |

![notWorkingSearch](../assets/notWorkingSearch.png)
![classroom](../assets/iconClassroom.png)
![assignmenticon](../assets/assignmenticon.png)

**Good:**  
- The UI elements for the most part are uniform across the entire website. 
- The website adheres to common design conventions, (profile notifications and search on top right).
- The website does't have any conflicting styles across the pages.

**Bad:**  
- The browser's undo/redo buttons don't always work correctly across tabs.
    - Example: Navigating from `Home` to `Classrooms` and pressing the browser's `Go-Back` button, doesn't return the user back to `Home`. 
    - However if the order is reversed and go from `Classrooms` to `Home` then the `Go-Back` button, works as expected.
- The search doesn't work as expected.
    - Example: Even though, we have `Human Computer Interaction` as a subject we are enrolled in, the search fails to find it.
- The icons for the classroom and assignment is the same.

Overall, the platform aligns well with Consistency & Standards, maintaining a uniform design and following common conventions. However, issues like inconsistent browser undo/redo behavior, non-functional search, and duplicate icons need attention for better consistency.

---

### Match Between System & Real World (Nielsen Only)  

| Jakob Nielsen |
|:---:|
| Match Between System & Real World |
| The interface should use familiar language, concepts, and symbols that reflect real-world experiences. |

![homePageMST](../assets/homePage.png)
![empty](../assets/emptyFieldPrevention.png)

#### Things To Look Out For:
- Use of real-world metaphors (e.g., trash can for delete)  
- Simple, user-friendly language instead of technical jargon  
- Intuitive icons and labels  
- Actions that mirror real-world expectations  

**Good:**  
- Use of real-world metaphors (classrooms, subjects, testpapers)
    - Icons of these labels also reflect real world objects, with `testpapers`, `subjects` encorporating icons that reflect their realworld counterparts
- Simple, user-friendly language instead of technical jargon  

Overall, the platform aligns well with Match Between System & Real World, using familiar metaphors (like classrooms, subjects, and test papers) and intuitive icons that reflect real-world objects. The language is simple and user-friendly, avoiding technical jargon.

---

### Help & Documentation (Nielsen Only)  

| Jakob Nielsen |
|:---:|
| Help & Documentation |
| Help should be easy to find and use when users need guidance. |

![faq](../assets/fAQ.png)
![homePageMST](../assets/homePage.png)
![livechat](../assets/livechat.png)
#### Things To Look Out For:
- Easily accessible help sections (FAQs, tooltips, documentation)  
- Searchable support resources  
- Contextual guidance (e.g., inline tips for forms)  
- Clear onboarding instructions for new users  

**Good:**  
- Easy accessible help sections
    - Very accessible FAQ section, with searchable questions
- Real time communication with an human representative

Overall, the platform provides easy access to help and documentation, with a searchable FAQ section and real-time communication with friendly human representatives. The guidance is clear, making it easy for users to get assistance when needed.
