CREATE TABLE [dbo].[CotizacionFormato]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_FCt] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Saludo1] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Saludo2] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Despedida] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Texto1] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Texto2] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Texto3] [varchar] (500) COLLATE Modern_Spanish_CI_AS NULL,
[Img] [image] NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionFormato] ADD CONSTRAINT [PK_CotizacionFormato] PRIMARY KEY CLUSTERED  ([RucE], [Cd_FCt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CotizacionFormato] ADD CONSTRAINT [FK_CotizacionFormato_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
