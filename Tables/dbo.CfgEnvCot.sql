CREATE TABLE [dbo].[CfgEnvCot]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CECot] [int] NOT NULL,
[Cd_CEC] [int] NOT NULL,
[Asunto] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Saludo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IC_JalaNcC] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[MsjPrev] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Despedida] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Firma] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_LinkAprob] [bit] NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvCot] ADD CONSTRAINT [PK_CfgEnvCot] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CECot]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgEnvCot] WITH NOCHECK ADD CONSTRAINT [FK_CfgEnvCot_CfgEnvCorreo] FOREIGN KEY ([RucE], [Cd_CEC]) REFERENCES [dbo].[CfgEnvCorreo] ([RucE], [Cd_CEC])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Config. Envio Correo', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCot', 'COLUMN', N'Cd_CEC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Config. Env. Cotizacion', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCot', 'COLUMN', N'Cd_CECot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se envia link Aprobacion', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCot', 'COLUMN', N'IB_LinkAprob'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador--> Null:NoJala, N:NomCliente, C:Contacto', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCot', 'COLUMN', N'IC_JalaNcC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Msj previo al listado de productos', 'SCHEMA', N'dbo', 'TABLE', N'CfgEnvCot', 'COLUMN', N'MsjPrev'
GO
