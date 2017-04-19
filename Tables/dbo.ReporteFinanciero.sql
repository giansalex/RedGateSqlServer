CREATE TABLE [dbo].[ReporteFinanciero]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_REF] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[NCorto] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReporteFinanciero] ADD CONSTRAINT [PK_ReporteFinaciero] PRIMARY KEY CLUSTERED  ([RucE], [Ejer], [Cd_REF]) ON [PRIMARY]
GO
