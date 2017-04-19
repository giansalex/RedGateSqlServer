CREATE TABLE [dbo].[PermisosxGP]
(
[Cd_GP] [int] NULL,
[Cd_Pm] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosxGP] ADD CONSTRAINT [FK_PermisosxGP_GrupoPermisos] FOREIGN KEY ([Cd_GP]) REFERENCES [dbo].[GrupoPermisos] ([Cd_GP])
GO
ALTER TABLE [dbo].[PermisosxGP] ADD CONSTRAINT [FK_PermisosxGP_Permisos] FOREIGN KEY ([Cd_Pm]) REFERENCES [dbo].[Permisos] ([Cd_Pm])
GO
