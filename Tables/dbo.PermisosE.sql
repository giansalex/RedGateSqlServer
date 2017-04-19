CREATE TABLE [dbo].[PermisosE]
(
[Cd_Prf] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GP] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosE] ADD CONSTRAINT [FK_PermisosE_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[PermisosE] ADD CONSTRAINT [FK_PermisosE_GrupoPermisos] FOREIGN KEY ([Cd_GP]) REFERENCES [dbo].[GrupoPermisos] ([Cd_GP])
GO
ALTER TABLE [dbo].[PermisosE] ADD CONSTRAINT [FK_PermisosE_Perfil] FOREIGN KEY ([Cd_Prf]) REFERENCES [dbo].[Perfil] ([Cd_Prf])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Item Permiso Empresa', 'SCHEMA', N'dbo', 'TABLE', N'PermisosE', 'COLUMN', N'Cd_GP'
GO
