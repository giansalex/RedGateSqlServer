CREATE TABLE [dbo].[Producto]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Pro] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodCo] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cta1] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta2] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[PrecioVta] [numeric] (13, 3) NULL,
[IB_IncIGV] [bit] NULL,
[IB_Exrdo] [bit] NULL,
[ValorVta] [numeric] (13, 3) NULL,
[IC_TipDcto] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Dcto] [numeric] (13, 3) NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Producto] ADD CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Pro]) ON [PRIMARY]
GO
