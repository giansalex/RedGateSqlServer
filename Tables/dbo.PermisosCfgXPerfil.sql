CREATE TABLE [dbo].[PermisosCfgXPerfil]
(
[Cd_Prf] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CfgPm] [smallint] NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosCfgXPerfil] ADD CONSTRAINT [IX_PermisosCfgXPerfil] UNIQUE NONCLUSTERED  ([Cd_Prf], [Cd_CfgPm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosCfgXPerfil] WITH NOCHECK ADD CONSTRAINT [FK_PermisosXPerfil_Perfil] FOREIGN KEY ([Cd_Prf]) REFERENCES [dbo].[Perfil] ([Cd_Prf])
GO
ALTER TABLE [dbo].[PermisosCfgXPerfil] ADD CONSTRAINT [FK_PermisosXPerfil_PermisosCfg] FOREIGN KEY ([Cd_CfgPm]) REFERENCES [dbo].[PermisosCfg] ([Cd_CfgPm])
GO
