# Navigation Testing Checklist

## Testing Philosophy

**Navigation is how users find things.** If they can't navigate, they can't use your app. Every broken link, every confusing menu, every dead end is a user who might not come back. Test navigation like you're lost in a building - because your users might be.

---

## 1. Primary Navigation Testing

### 1.1 Header/Top Navigation

For EACH nav item:
- [ ] Click navigates to correct page
- [ ] URL changes appropriately
- [ ] Page title matches nav item
- [ ] Content matches expectations from nav label
- [ ] Active/current state shown clearly
- [ ] Hover state visible (if applicable)
- [ ] Focus state visible (keyboard)
- [ ] Keyboard accessible (Tab to reach, Enter to activate)

### 1.2 Logo/Home Link

- [ ] Logo links to home page
- [ ] Logo is clickable (not just decorative)
- [ ] Works from all pages
- [ ] Clear visual feedback on hover
- [ ] Has appropriate alt text / aria-label

### 1.3 Navigation on Mobile

```
Resize to 375px width
```

- [ ] Hamburger menu visible
- [ ] Hamburger menu clickable
- [ ] Menu opens smoothly
- [ ] All nav items visible in mobile menu
- [ ] Can close menu (X, outside click, escape)
- [ ] Menu closes after selection
- [ ] Active state visible in mobile menu
- [ ] Submenu navigation works (if applicable)

### 1.4 Dropdown Menus (if present)

**Mouse interaction:**
- [ ] Hover opens dropdown
- [ ] Moving to dropdown keeps it open
- [ ] Moving away closes dropdown
- [ ] Click on parent item (if also a link)
- [ ] Smooth animation (not jarring)

**Keyboard interaction:**
- [ ] Tab reaches dropdown trigger
- [ ] Enter/Space opens dropdown
- [ ] Arrow keys navigate items
- [ ] Enter selects item
- [ ] Escape closes dropdown
- [ ] Tab moves through items (or closes)

**Content:**
- [ ] All submenu items clickable
- [ ] Submenu items link to correct pages
- [ ] Visual hierarchy clear
- [ ] Not too many items (overwhelming)

---

## 2. Secondary Navigation

### 2.1 Sidebar Navigation (if present)

- [ ] All items visible or scrollable
- [ ] Current section highlighted
- [ ] Collapse/expand works (if applicable)
- [ ] Sticky behavior works (if applicable)
- [ ] Doesn't overlap content
- [ ] Works at all viewport sizes

### 2.2 Footer Navigation

- [ ] All footer links work
- [ ] External links open correctly (new tab?)
- [ ] Legal links present (privacy, terms)
- [ ] Contact information links work (email, phone)
- [ ] Social media links work
- [ ] Sitemap link works (if present)

### 2.3 Breadcrumbs (if present)

- [ ] Shows current location
- [ ] All levels clickable (except current)
- [ ] Links navigate correctly
- [ ] Updates on navigation
- [ ] Truncates gracefully (long paths)
- [ ] Separator visible and consistent

---

## 3. In-Page Navigation

### 3.1 Anchor Links

- [ ] Smooth scroll to section (if designed)
- [ ] Section visible after scroll (not under sticky header)
- [ ] URL hash updates (#section)
- [ ] Browser back returns to previous scroll position
- [ ] Works with keyboard Enter

### 3.2 Tab Navigation (within page)

- [ ] All tabs clickable
- [ ] Active tab clearly indicated
- [ ] Content changes on tab click
- [ ] URL updates (if deep-linkable)
- [ ] Keyboard arrows switch tabs
- [ ] Content not visible until tab selected (or is it?)
- [ ] Focus moves appropriately

### 3.3 Pagination (if present)

- [ ] Page numbers work
- [ ] Next/Previous work
- [ ] First/Last work (if present)
- [ ] Current page highlighted
- [ ] Disabled state on first/last pages
- [ ] URL updates with page number
- [ ] Content updates correctly
- [ ] Scroll position handled (back to top?)
- [ ] Page count accurate

### 3.4 Infinite Scroll (if present)

- [ ] More content loads on scroll
- [ ] Loading indicator visible
- [ ] No duplicate content
- [ ] Works with fast scrolling
- [ ] End state clear (no more content)
- [ ] Back button position preserved
- [ ] Refresh behavior reasonable

---

## 4. Browser Navigation

### 4.1 Back Button

For each major action, test back button:
- [ ] After navigating to new page
- [ ] After form submission
- [ ] After opening/closing modal
- [ ] After changing tabs
- [ ] After filter/search
- [ ] Returns to correct page
- [ ] Returns to correct scroll position
- [ ] Returns to correct state (filters, etc.)

### 4.2 Forward Button

After using back button:
- [ ] Forward returns to previous page
- [ ] State is correct
- [ ] No errors

### 4.3 Refresh/Reload

On each page:
- [ ] Page reloads correctly
- [ ] No errors
- [ ] State preserved (if should be)
- [ ] State reset (if should be)
- [ ] Login state preserved
- [ ] Form data handling (warning?)

### 4.4 Direct URL Access (Deep Linking)

Test each route directly:
- [ ] Home page: /
- [ ] Subpages: /about, /contact, etc.
- [ ] Dynamic pages: /product/123
- [ ] Filtered views: /products?category=shoes
- [ ] Authenticated pages: /dashboard (redirect to login?)
- [ ] Non-existent pages: /asdfasdfasdf (404?)

---

## 5. Link Testing

### 5.1 Internal Links

For EVERY internal link on EVERY page:
- [ ] Link is clickable
- [ ] Link goes to correct destination
- [ ] No broken links (404)
- [ ] No infinite redirects
- [ ] Opens in same tab (not new)

### 5.2 External Links

- [ ] Link works
- [ ] Opens in new tab (typically)
- [ ] Has indicator (icon, "opens in new tab")
- [ ] rel="noopener noreferrer" (security)
- [ ] Target site accessible

### 5.3 Email Links (mailto:)

- [ ] Click opens email client
- [ ] Email address correct
- [ ] Subject pre-filled (if specified)

### 5.4 Phone Links (tel:)

- [ ] Click initiates call (on mobile)
- [ ] Number is correct
- [ ] On desktop: appropriate behavior

### 5.5 Download Links

- [ ] Click starts download
- [ ] Correct file downloads
- [ ] File is not corrupted
- [ ] Filename is meaningful
- [ ] File type indicator present

---

## 6. Error State Navigation

### 6.1 404 Page

- [ ] Custom 404 page exists (not server default)
- [ ] Page is helpful (suggestions)
- [ ] Has navigation back to main site
- [ ] Search available (if applicable)
- [ ] Design matches rest of site
- [ ] Doesn't break browser navigation

### 6.2 Error Page (500, etc.)

- [ ] Error page exists
- [ ] Error message is user-friendly
- [ ] Has way to return to working page
- [ ] Doesn't expose technical details

### 6.3 Unauthorized Access

- [ ] Trying to access protected page
- [ ] Redirects to login
- [ ] Returns to intended page after login
- [ ] Clear message about why redirected

### 6.4 Forbidden Access

- [ ] Trying to access page without permission
- [ ] Shows appropriate error
- [ ] Doesn't redirect infinitely
- [ ] Has navigation away

---

## 7. Search Navigation (if present)

### 7.1 Search Input

- [ ] Search field accessible
- [ ] Placeholder text helpful
- [ ] Can type query
- [ ] Enter submits search
- [ ] Search button works
- [ ] Clear button works (if present)

### 7.2 Search Results

- [ ] Results display for valid query
- [ ] Results are relevant
- [ ] Results are clickable
- [ ] Click navigates to item
- [ ] No results state is clear
- [ ] Pagination/infinite scroll works
- [ ] Can refine search

### 7.3 Search URL

- [ ] Query in URL (?q=term)
- [ ] URL is shareable
- [ ] Refresh preserves search
- [ ] Back returns to results

---

## 8. Skip Links and Accessibility Navigation

### 8.1 Skip to Content

- [ ] Skip link exists (visible on focus)
- [ ] Skips past navigation
- [ ] Lands on main content
- [ ] Works on all pages

### 8.2 Keyboard Navigation Flow

Tab through entire page:
- [ ] Logical order (top to bottom, left to right)
- [ ] No hidden elements receive focus
- [ ] All interactive elements focusable
- [ ] No focus traps (except modals)
- [ ] Focus visible at all times

---

## 9. State-Dependent Navigation

### 9.1 Logged In vs Logged Out

**Logged Out:**
- [ ] Public pages accessible
- [ ] Protected pages redirect
- [ ] Login/Register links visible
- [ ] Profile/Dashboard hidden

**Logged In:**
- [ ] Protected pages accessible
- [ ] Profile/Dashboard visible
- [ ] Logout link visible
- [ ] Login/Register hidden

### 9.2 Role-Based Navigation

- [ ] Admin sees admin links
- [ ] Regular user doesn't see admin links
- [ ] Correct nav for each role
- [ ] Direct URL respects permissions

### 9.3 Feature Flags/Incomplete Features

- [ ] Disabled features not navigable
- [ ] Coming soon sections handled
- [ ] No dead ends

---

## 10. Performance Navigation

### 10.1 Page Load Times

Navigate to each page:
- [ ] Page loads in reasonable time (<3s)
- [ ] Loading indicator if slow
- [ ] Content doesn't jump around (CLS)
- [ ] Interactive quickly

### 10.2 Slow Network Navigation

With throttled network (Slow 3G):
- [ ] Pages still load
- [ ] Loading states visible
- [ ] Timeout handling graceful
- [ ] Can navigate away if stuck

---

## Common Navigation Issues

1. **Broken link** - 404, times out, or errors
2. **Wrong destination** - Links to unexpected page
3. **Missing active state** - Can't tell where you are
4. **Mobile menu broken** - Hamburger doesn't work
5. **Dropdown inaccessible** - Keyboard can't open
6. **Back button breaks** - SPA navigation issues
7. **Deep link fails** - Direct URL doesn't work
8. **Infinite redirect** - Login loop, permission loop
9. **Focus trap** - Can't Tab away
10. **Missing skip link** - Keyboard users must Tab through everything

---

## Navigation Map Template

Create a map of all navigable paths:

```
Home (/)
├── About (/about)
├── Products (/products)
│   ├── Category A (/products/category-a)
│   │   └── Product 1 (/products/category-a/1)
│   └── Category B (/products/category-b)
├── Contact (/contact)
├── Login (/login) [logged out only]
├── Register (/register) [logged out only]
├── Dashboard (/dashboard) [logged in only]
│   ├── Profile (/dashboard/profile)
│   └── Settings (/dashboard/settings)
└── 404 (any invalid path)
```

Test EVERY path in this map.
