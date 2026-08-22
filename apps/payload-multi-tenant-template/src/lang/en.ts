/**
 * English (source locale).
 *
 * `custom` is Payload's project-translation namespace — runtime keys are `custom:…` in `t()`.
 * @see https://payloadcms.com/docs/configuration/i18n#custom-translations
 */
export default {
  custom: {
    roles: {
      SYSTEM_ADMIN: 'System administrator',
      SYSTEM_USER: 'System user',
      TENANT_ADMIN: 'Workspace administrator',
      TENANT_USER: 'Workspace user',
    },
    defaultTenant: 'Default workspace',
    frontend: {
      appName: 'Payload Multi-Tenant Template',
      logoAlt: 'Payload Multi-Tenant Template',
      welcome: 'Welcome',
      welcomeBack: 'Welcome back',
      signedInPrefix: 'Signed in as ',
      signedOutBlurb: 'Your new Payload + Tailwind stack is ready.',
      openAdmin: 'Open admin',
      documentation: 'Documentation',
      chooseLanguage: 'Choose language',
      tagline: 'Built with Payload CMS, Tailwind, and shadcn/ui',
    },
    meta: {
      title: 'Payload Multi-Tenant Template',
      description: 'Payload CMS multi-tenant template with Tailwind and shadcn/ui',
    },
  },
} as const
