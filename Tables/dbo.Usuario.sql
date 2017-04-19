CREATE TABLE [dbo].[Usuario]
(
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Pass] [nvarchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomComp] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Trab] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prf] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nivel] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[IB_TipCamCrear] [bit] NULL,
[IB_TipCamMdf] [bit] NULL,
[IB_TipCamElim] [bit] NULL,
[Correo1] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[GUID] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cargo] [nvarchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Numero] [nvarchar] (20) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED  ([NomUsu]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [FK_Usuario_Perfil] FOREIGN KEY ([Cd_Prf]) REFERENCES [dbo].[Perfil] ([Cd_Prf])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Perfil', 'SCHEMA', N'dbo', 'TABLE', N'Usuario', 'COLUMN', N'Cd_Prf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Trabajador', 'SCHEMA', N'dbo', 'TABLE', N'Usuario', 'COLUMN', N'Cd_Trab'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Completo', 'SCHEMA', N'dbo', 'TABLE', N'Usuario', 'COLUMN', N'NomComp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'Usuario', 'COLUMN', N'NomUsu'
GO
