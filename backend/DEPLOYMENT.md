# How to Deploy Backend to Vercel

Follow these steps to get your backend live on Vercel:

### 1. Install Vercel CLI
If you haven't already, install the Vercel CLI globally:
```bash
npm install -g vercel
```

### 2. Login to Vercel
Run the login command and follow the instructions in your browser:
```bash
vercel login
```

### 3. Deploy
Navigate to the `backend` directory in your terminal:
```bash
cd backend
```
Then run the deployment command:
```bash
vercel
```
- When asked "Set up and deploy?", type `y`.
- For "Which scope?", select your account.
- For "Link to existing project?", type `n`.
- For "What's your project's name?", type `ki-sun-app-backend` (or your preferred name).
- For "In which directory is your code located?", use the default `./`.
- It will automatically detect the settings from `vercel.json`.

### 4. Setup Environment Variables
After the first deployment attempt (or during setup on Vercel Dashboard):
1. Go to your Vercel Project Settings.
2. Go to **Environment Variables**.
3. Add the variables from your `.env` file, especially:
   - `MONGO_URI` (Use a MongoDB Atlas connection string, not localhost).
   - `JWT_SECRET`
   - `NODE_ENV` (Set to `production`)

### 5. Final Production Deployment
Once the project is linked and variables are set, deploy to production:
```bash
vercel --prod
```

### Note on 24/7 Availability
Vercel's "Serverless Functions" are always available. They spin up on request. Unlike a traditional VPS, you don't need to "keep" them online; Vercel handles that automatically.
