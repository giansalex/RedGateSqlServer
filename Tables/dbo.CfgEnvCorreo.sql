CREATE TABLE [dbo].[CfgEnvCorreo]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CEC] [int] NOT NULL,
[Host] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Puerto] [int] NULL,
[Correo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Pass] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[NomEnv] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IB_SSL] [bit] NULL,
[Estado] [bit] NULL,
[EsPrincipal] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvCorreo] ADD CONSTRAINT [PK_CfgEnvCorreo] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CEC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvCorreo] WITH NOCHECK ADD CONSTRAINT [FK_CfgEnvCorreo_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Config. Envio Correo', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCorreo', 'COLUMN', N'Cd_CEC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DisplayName', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCorreo', 'COLUMN', N'NomEnv'
GO
