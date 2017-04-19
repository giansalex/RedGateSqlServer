CREATE TABLE [dbo].[CfgUsu]
(
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_NA] [bit] NULL,
[Intv_Ntf] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgUsu] ADD CONSTRAINT [FK_CfgUsu_Usuario] FOREIGN KEY ([NomUsu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Notificaciones', 'SCHEMA', N'dbo', 'TABLE', N'CfgUsu', 'COLUMN', N'IB_NA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tiempo Intervalo Notificaciones', 'SCHEMA', N'dbo', 'TABLE', N'CfgUsu', 'COLUMN', N'Intv_Ntf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'CfgUsu', 'COLUMN', N'NomUsu'
GO
