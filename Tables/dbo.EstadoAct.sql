CREATE TABLE [dbo].[EstadoAct]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_EA] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoAct] ADD CONSTRAINT [PK_EstadoAct] PRIMARY KEY CLUSTERED  ([RucE], [Cd_EA]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstadoAct] ADD CONSTRAINT [FK_EstadoAct_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
