CREATE TABLE [dbo].[AccesoE]
(
[Cd_Prf] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GA] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccesoE] ADD CONSTRAINT [IX_AccesoE] UNIQUE NONCLUSTERED  ([Cd_Prf], [RucE], [Cd_GA]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccesoE] WITH NOCHECK ADD CONSTRAINT [FK_AccesoE_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[AccesoE] WITH NOCHECK ADD CONSTRAINT [FK_AccesoE_GrupoAcceso] FOREIGN KEY ([Cd_GA]) REFERENCES [dbo].[GrupoAcceso] ([Cd_GA])
GO
ALTER TABLE [dbo].[AccesoE] WITH NOCHECK ADD CONSTRAINT [FK_AccesoE_Perfil] FOREIGN KEY ([Cd_Prf]) REFERENCES [dbo].[Perfil] ([Cd_Prf])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Permiso Empresa', 'SCHEMA', N'dbo', 'TABLE', N'AccesoE', 'COLUMN', N'Cd_GA'
GO
