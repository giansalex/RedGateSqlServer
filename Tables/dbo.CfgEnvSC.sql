CREATE TABLE [dbo].[CfgEnvSC]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CESCo] [int] NOT NULL,
[Cd_CEC] [int] NOT NULL,
[Asunto] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Saludo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IC_JalaNpC] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[MsjPrev] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Despedida] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Firma] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_LinkForm] [bit] NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvSC] ADD CONSTRAINT [PK_CfgEnvSC] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CESCo]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvSC] WITH NOCHECK ADD CONSTRAINT [FK_CfgEnvSC_CfgEnvCorreo] FOREIGN KEY ([RucE], [Cd_CEC]) REFERENCES [dbo].[CfgEnvCorreo] ([RucE], [Cd_CEC])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Config. Envio Correo', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvSC', 'COLUMN', N'Cd_CEC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Config. Env. Solicitud de Compra', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvSC', 'COLUMN', N'Cd_CESCo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se envia link de form web', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvSC', 'COLUMN', N'IB_LinkForm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador--> Null:NoJala, N:NomProveedor, C:Contacto', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvSC', 'COLUMN', N'IC_JalaNpC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Msj previo al listado de productos', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvSC', 'COLUMN', N'MsjPrev'
GO
