CREATE TABLE [dbo].[Empresa]
(
[Ruc] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RSocial] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecIni] [smalldatetime] NOT NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direccion] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telef] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Logo] [image] NULL,
[Cd_MdaP] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MdaS] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CA01] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Empresa] ADD CONSTRAINT [PK_Empresa] PRIMARY KEY CLUSTERED  ([Ruc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Empresa] ADD CONSTRAINT [FK_Empresa_Moneda] FOREIGN KEY ([Cd_MdaP]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[Empresa] ADD CONSTRAINT [FK_Empresa_Moneda1] FOREIGN KEY ([Cd_MdaS]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
