CREATE TABLE [dbo].[TipActividad]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TA] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipActividad] ADD CONSTRAINT [PK_TipActividad] PRIMARY KEY CLUSTERED  ([RucE], [Cd_TA]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipActividad] ADD CONSTRAINT [FK_TipActividad_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
