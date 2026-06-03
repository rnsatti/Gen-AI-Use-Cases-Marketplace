# AI Agent Marketplace — CMS Setup Guide

A content-managed version of the Agent Marketplace. All use cases and agents live in a Supabase database. Edit content through the admin panel GUI — the marketplace frontend updates live.

---

## What's in this repo

| File | Purpose |
|---|---|
| `index.html` | The marketplace frontend (public-facing) |
| `admin.html` | Admin panel to add/edit/delete use cases and agents |
| `config.js` | Your Supabase credentials (fill this in once) |
| `schema.sql` | Run once in Supabase to create the database tables |
| `seed.sql` | Run once to load all the existing data |
| `README.md` | This file |

---

## Step 1 — Create a Supabase project

1. Go to [https://supabase.com](https://supabase.com) and sign up (free)
2. Click **New Project**
3. Give it a name (e.g. `agent-marketplace`) and set a database password
4. Choose a region close to your team
5. Wait ~2 minutes for it to provision

---

## Step 2 — Run the schema

1. In your Supabase project, go to **SQL Editor** in the left sidebar
2. Click **New Query**
3. Paste the entire contents of `schema.sql`
4. Click **Run**

You should see "Success" and 3 new tables: `use_cases`, `agents`, `agent_steps`.

---

## Step 3 — Load the data

1. In SQL Editor, create another **New Query**
2. Paste the entire contents of `seed.sql`
3. Click **Run**

This loads all 7 use cases, all agents, and all steps.

---

## Step 4 — Get your API credentials

1. In Supabase, go to **Project Settings** → **API**
2. Copy:
   - **Project URL** (looks like `https://abcdefgh.supabase.co`)
   - **anon / public** key (the long string under "Project API keys")

---

## Step 5 — Fill in config.js

Open `config.js` and replace the placeholder values:

```js
const SUPABASE_URL  = 'https://YOUR_PROJECT_ID.supabase.co';  // paste your Project URL
const SUPABASE_ANON = 'YOUR_ANON_PUBLIC_KEY';                 // paste your anon key
```

Save the file.

---

## Step 6 — Create your admin user

1. In Supabase, go to **Authentication** → **Users**
2. Click **Add User** → **Create New User**
3. Enter your work email and a strong password
4. This is the login you'll use for `admin.html`

---

## Step 7 — Deploy to GitHub Pages

1. Create a **private** repository on GitHub
2. Upload all 6 files (`index.html`, `admin.html`, `config.js`, `schema.sql`, `seed.sql`, `README.md`)
3. Go to **Settings** → **Pages**
4. Under "Source", select **Deploy from a branch** → `main` → `/ (root)`
5. Click **Save**
6. After ~1 minute, your site will be live at `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`

> The marketplace is at `/index.html` and the admin panel is at `/admin.html`

---

## How to update content

### Through the Admin Panel (recommended)
1. Go to `admin.html` on your deployed site
2. Sign in with the email/password you created in Step 6
3. Use the **Use Cases** or **Agents** sections to add, edit, or delete
4. Changes appear on the marketplace immediately — no code push needed

### Directly in Supabase (for bulk changes)
1. Go to **Table Editor** in Supabase
2. Select `use_cases`, `agents`, or `agent_steps`
3. Edit rows directly in the spreadsheet-style interface

---

## Data structure reference

### Use Cases (`use_cases` table)
| Column | Type | Description |
|---|---|---|
| `id` | text | Unique slug e.g. `tc-gen` |
| `name` | text | Full display name |
| `short_desc` | text | Card description |
| `tagline` | text | Full drawer description |
| `status` | text | `active` / `planned` / `exploring` / `pipeline` |
| `color` | text | Hex colour for the card bar |
| `group_id` | text | Filter group: `p1` / `p2` / `p3` / `dsr` / `mom` / `sprint` / `defect` |
| `output_desc` | text | "What this produces" section |
| `agent_ids` | text[] | Ordered array of agent IDs in the pipeline |
| `shared_ids` | text[] | Agent IDs that are shared across use cases |
| `sort_order` | integer | Display order |

### Agents (`agents` table)
| Column | Type | Description |
|---|---|---|
| `id` | text | Unique slug e.g. `jira-connector` |
| `name` | text | Full display name |
| `short_desc` | text | Card description |
| `tagline` | text | Full drawer description |
| `color` | text | Hex colour |
| `group_id` | text | `core` / `p1` / `p2` / `p3` / `other` |
| `inputs` | text[] | Input items shown in the drawer |
| `outputs` | text[] | Output items shown in the drawer |
| `confirmed` | boolean | Whether shown in the confirmed agents view |
| `sort_order` | integer | Display order |

### Agent Steps (`agent_steps` table)
| Column | Type | Description |
|---|---|---|
| `agent_id` | text | Foreign key to `agents.id` |
| `step_number` | text | `1`, `2`, `3`, or `★` for special steps |
| `step_name` | text | Step heading |
| `step_desc` | text | Step body text |
| `is_special` | boolean | `true` for ★ steps (gradient badge) |
| `sort_order` | integer | Display order within the agent |

---

## Total cost

| Component | Cost |
|---|---|
| Supabase (database + API + Auth) | Free |
| GitHub private repository | Free |
| GitHub Pages hosting | Free |
| **Total** | **$0** |

The free Supabase tier includes 500 MB storage, unlimited API requests, and up to 50,000 auth users. Your data is approximately 0.006% of the free storage limit.
