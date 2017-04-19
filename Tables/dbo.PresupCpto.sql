CREATE TABLE [dbo].[PresupCpto]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CPr] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PresupCpto] ADD CONSTRAINT [PK_PresupCpto] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CPr]) ON [PRIMARY]
GO
