CREATE TABLE [dbo].[Contacto]
(
[ID_Gen] [int] NOT NULL,
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telf] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Correo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cargo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Prin] [bit] NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contacto] ADD CONSTRAINT [PK_Contacto] PRIMARY KEY CLUSTERED  ([ID_Gen]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contacto] ADD CONSTRAINT [FK_Contacto_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[Contacto] WITH NOCHECK ADD CONSTRAINT [FK_Contacto_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contacto Principal', 'SCHEMA', N'dbo', 'TABLE', N'Contacto', 'COLUMN', N'IB_Prin'
GO
