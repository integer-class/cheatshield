<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CheatShield - Secure Online Exams</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: white;
            color: #111;
            line-height: 1.5;
        }

        .container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .background-pattern {
            position: absolute;
            inset: 0;
            background-image: radial-gradient(#00000011 1px, transparent 1px);
            background-size: 16px 16px;
            z-index: 0;
        }

        .content {
            text-align: center;
            max-width: 1000px;
            z-index: 1;
        }

        .logo {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            border: 3px solid black;
            border-radius: 24px;
            padding: 1rem;
            background: white;
            box-shadow: 8px 8px 0px black;
        }

        .logo svg {
            width: 100%;
            height: 100%;
        }

        h1 {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 1rem;
        }

        .description {
            font-size: 1.25rem;
            color: #555;
            margin-bottom: 2rem;
        }

        .download-btn {
            display: inline-block;
            background: white;
            color: black;
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: bold;
            font-size: 1.125rem;
            cursor: pointer;
            border: 3px solid black;
            position: relative;
            box-shadow: 8px 8px 0px black;
            transition: all 0.2s ease;
        }

        .download-btn:hover {
            transform: translate(-4px, -4px);
            box-shadow: 12px 12px 0px black;
        }

        .download-btn:active {
            transform: translate(4px, 4px);
            box-shadow: 4px 4px 0px black;
        }

        .beta-badge {
            position: absolute;
            top: 4px;
            right: 1rem;
            background: black;
            color: white;
            font-size: 0.75rem;
            padding: 2px 8px;
            border-radius: 999px;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 4rem;
            padding: 0 1rem;
        }

        .feature {
            background: white;
            padding: 2rem;
            border-radius: 16px;
            border: 3px solid black;
            box-shadow: 8px 8px 0px black;
            transition: all 0.2s ease;
            text-align: left;
        }

        .feature-icon {
            width: 48px;
            height: 48px;
            background: black;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            border: 2px solid black;
        }

        .feature-icon svg {
            width: 24px;
            height: 24px;
            color: white;
        }

        .feature-title {
            font-size: 1.25rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: black;
        }

        .feature-text {
            font-size: 1rem;
            color: #555;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="background-pattern"></div>
        <div class="content">
            <div class="logo">
                <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M50 5L15 20V45C15 69.5 29.5 92.5 50 95C70.5 92.5 85 69.5 85 45V20L50 5Z" stroke="black" stroke-width="4" fill="white"/>
                    <path d="M40 50L45 55L60 40" stroke="black" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>

            <h1>CheatShield</h1>
            <p class="description">
                Protect academic integrity with AI-powered face detection during online exams
            </p>

            <button class="download-btn">
                Download CheatShield
                <span class="beta-badge">Beta</span>
            </button>

            <div class="features">
                <div class="feature">
                    <div class="feature-icon">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                        </svg>
                    </div>
                    <h3 class="feature-title">Real-time Detection</h3>
                    <p class="feature-text">
                        Advanced AI monitors students during exams, detecting multiple faces, screen sharing, and suspicious movements in real-time to ensure exam integrity.
                    </p>
                </div>

                <div class="feature">
                    <div class="feature-icon">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                        </svg>
                    </div>
                    <h3 class="feature-title">Secure Testing</h3>
                    <p class="feature-text">
                        Create a secure testing environment with our lockdown app. Prevent unauthorized resources, block screen capturing, and disable app navigation.
                    </p>
                </div>

                <div class="feature">
                    <div class="feature-icon">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                        </svg>
                    </div>
                    <h3 class="feature-title">Privacy First</h3>
                    <p class="feature-text">
                        Your privacy matters. Face detection happens securely on the server, and we never store video feeds or personal data.
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
