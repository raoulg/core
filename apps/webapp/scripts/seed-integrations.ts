import { PrismaClient } from "@core/database";

const prisma = new PrismaClient();

const integrations = [
    {
        name: "GitHub extension",
        slug: "github",
        description: "Plan, track, and manage your agile and software development projects in GitHub. Customize your workflow, collaborate, and release great software.",
        icon: "github",
        spec: {
            name: "GitHub extension",
            key: "github",
            description: "Plan, track, and manage your agile and software development projects in GitHub. Customize your workflow, collaborate, and release great software.",
            icon: "github",
            schedule: {
                frequency: "*/5 * * * *",
            },
            mcp: {},
            auth: {
                OAuth2: {
                    token_url: "https://github.com/login/oauth/access_token",
                    authorization_url: "https://github.com/login/oauth/authorize",
                    scopes: [
                        "user",
                        "public_repo",
                        "repo",
                        "notifications",
                        "gist",
                        "read:org",
                        "repo_hooks",
                    ],
                    scope_separator: ",",
                },
            },
        },
    },
    {
        name: "Linear extension",
        slug: "linear",
        description: "Plan, track, and manage your agile and software development projects in Linear. Customize your workflow, collaborate, and release great software.",
        icon: "linear",
        spec: {
            name: "Linear extension",
            key: "linear",
            description: "Plan, track, and manage your agile and software development projects in Linear. Customize your workflow, collaborate, and release great software.",
            icon: "linear",
            schedule: {
                frequency: "*/5 * * * *",
            },
            auth: {
                api_key: {
                    type: "string",
                    label: "Linear API Key",
                },
            },
            mcp: {
                type: "cli",
            },
        },
    },
    {
        name: "Gmail extension",
        slug: "gmail",
        description: "Connect your workspace to Gmail. Monitor emails, send messages, and manage your email workflow",
        icon: "gmail",
        spec: {
            name: "Gmail extension",
            key: "gmail",
            description: "Connect your workspace to Gmail. Monitor emails, send messages, and manage your email workflow",
            icon: "gmail",
            mcp: {
                type: "cli",
            },
            schedule: {
                frequency: "*/15 * * * *",
            },
            auth: {
                OAuth2: {
                    token_url: "https://oauth2.googleapis.com/token",
                    authorization_url: "https://accounts.google.com/o/oauth2/v2/auth",
                    scopes: [
                        "https://mail.google.com",
                        "https://www.googleapis.com/auth/gmail.labels",
                        "https://www.googleapis.com/auth/userinfo.email",
                        "https://www.googleapis.com/auth/userinfo.profile",
                    ],
                    scope_identifier: "scope",
                    scope_separator: " ",
                    token_params: {
                        access_type: "offline",
                        prompt: "consent",
                    },
                    authorization_params: {
                        access_type: "offline",
                        prompt: "consent",
                    },
                },
            },
        },
    },
    {
        name: "Slack extension",
        slug: "slack",
        description: "Connect your workspace to Slack. Run your workflows from slack bookmarks",
        icon: "slack",
        spec: {
            name: "Slack extension",
            key: "slack",
            description: "Connect your workspace to Slack. Run your workflows from slack bookmarks",
            icon: "slack",
            mcp: {
                type: "cli",
            },
            auth: {
                OAuth2: {
                    token_url: "https://slack.com/api/oauth.v2.access",
                    authorization_url: "https://slack.com/oauth/v2/authorize",
                    scopes: [
                        "stars:read",
                        "team:read",
                        "stars:write",
                        "users:read",
                        "channels:read",
                        "groups:read",
                        "im:read",
                        "im:history",
                        "mpim:read",
                        "mpim:write",
                        "mpim:history",
                        "channels:history",
                        "chat:write",
                        "reactions:read",
                        "reactions:write",
                        "users.profile:read",
                        "files:read",
                        "files:write",
                        "reminders:read",
                        "reminders:write",
                        "search:read",
                    ],
                    scope_identifier: "user_scope",
                    scope_separator: ",",
                },
            },
        },
    },
    {
        name: "Notion",
        slug: "notion",
        description: "Connect your workspace to Notion. Create, read, and manage pages, databases, and blocks with powerful automation",
        icon: "notion",
        spec: {
            name: "Notion",
            key: "notion",
            description: "Connect your workspace to Notion. Create, read, and manage pages, databases, and blocks with powerful automation",
            icon: "notion",
            mcp: {
                type: "cli",
            },
            auth: {
                OAuth2: {
                    token_url: "https://api.notion.com/v1/oauth/token",
                    authorization_url: "https://api.notion.com/v1/oauth/authorize",
                    scopes: [],
                    scope_separator: " ",
                    authorization_params: {
                        owner: "user",
                    },
                    token_request_auth_method: "basic",
                },
            },
        },
    },
];

async function seed() {
    console.log("Seeding integrations...");
    for (const integration of integrations) {
        console.log(`Upserting ${integration.name}...`);
        await prisma.integrationDefinitionV2.upsert({
            where: { name: integration.name },
            update: {
                slug: integration.slug,
                description: integration.description,
                icon: integration.icon,
                spec: integration.spec,
            },
            create: {
                name: integration.name,
                slug: integration.slug,
                description: integration.description,
                icon: integration.icon,
                spec: integration.spec,
                // Make sure it's global
                workspaceId: null,
            },
        });
    }
    console.log("Seeding complete.");
}

seed()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
