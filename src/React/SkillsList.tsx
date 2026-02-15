import React from "react";

type Props = {
  videoUrl?: string;
  photoUrl?: string;
};

const SkillsList: React.FC<Props> = ({ videoUrl, photoUrl }) => {
  return (
    <div className="text-left w-full pt-3 md:pt-9">
      <h3 className="text-[var(--white)] text-3xl md:text-4xl font-semibold md:mb-6">
        Presentación
      </h3>

      {/* Contenedor grande */}
      <div className="mt-6 grid grid-cols-1 lg:grid-cols-2 gap-8 w-full">
        {/* VIDEO */}
        <div className="w-full">
          <p className="text-[var(--white-icon)] text-sm mb-3">Video</p>

          <div className="w-full bg-[#1414149c] rounded-3xl border border-[var(--white-icon-tr)] overflow-hidden">
            {/* En desktop lo hacemos ALTO para que se vea GRANDE */}
            <div className="relative w-full h-[520px] md:h-[620px]">
              {videoUrl ? (
                <iframe
                  className="absolute inset-0 w-full h-full"
                  src={videoUrl}
                  title="Video de presentación"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                  allowFullScreen
                />
              ) : (
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="text-[var(--white-icon)] text-sm opacity-80">
                    Aquí va tu video
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* FOTO */}
        <div className="w-full">
          <p className="text-[var(--white-icon)] text-sm mb-3">Foto</p>

          <div className="w-full bg-[#1414149c] rounded-3xl border border-[var(--white-icon-tr)] overflow-hidden">
            <div className="relative w-full h-[520px] md:h-[620px]">
              {photoUrl ? (
                <img
                  src={photoUrl}
                  alt="Foto de presentación"
                  className="absolute inset-0 w-full h-full object-cover"
                  loading="lazy"
                />
              ) : (
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="text-[var(--white-icon)] text-sm opacity-80">
                    Aquí va tu foto
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SkillsList;
